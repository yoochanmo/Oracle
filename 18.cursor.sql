/*
	1 . Cursor(커서)??
	
			오라클 서버는 sql문을 실행하고 처리한 정보를 저장하기 위해 private sql area라는
			
			메모리 작업공간을 이용한다. 이 영역에 이름을 부여하고 저장된 정보를 처리할 수 있게
			
			해주는 데 이를 커서(Cursor)라고 한다.
			
			Cursor에는 dml문과 dql(select)문에 의해 내부적으로 선언되는 묵시적커서와 명시적커서가 있다.
			
			pl/sql에서는 select문은 한개의 row에만 검색할 수 있기 때문에 하나 이상의 row를
			
			검색하기 위해서는 명시적 커서를 사용해야 한다.
			
			묵시적커서의 정의는 pl/sql 블럭의 begin ~ end에 sql문이 있다면 pl/sql은 "SQL"이라는 이름의
			
			커서를 자동으로 생성한다.
			
			
			
	2 . Cursor의 종류
	
			1) 묵시적(암묵적, implicit) 커서
			
				묵시적커서는 오라클이나 pl/sql실행 매커니즘에 의해 처리되는 sql문장이 처리 되는 곳에 대한 익명의
				
				주소이다. 오라클데이터베이스에서 실행되는 모든 SQL문장은 묵시적 커서가 생성되면 커서속성을 사용할 수 있다.
				
				묵시적커서는 SQL문이 실행되는 순간 자동으로 open 과 close가 된다. 암묵적커서의 속성은 
				
				sql%rowcount : 해당 sql문에서 영행을 받는 행의 갯수
				
				sql%found		 : 해당 sql문에서 행의 갯수가 한개 이상일 때 true를 리턴
				
				sql%notfound : 해당 sql문에서 행의 갯수가 없을 때 true를 리턴
				
				sql%isopen   : 항상 false, 묵시적커서가 open여부를 리턴
			 
			2) 명시적(explicit) 커서 
			
				개발자에 의해 선언되고 이름이 부여되는 커서를 말한다. 명시적 커서의 진행순서는
				
				선언 -> open -> fetch -> close 로 진행한다.
				
					a . 문법 : cursor 커서명 is select문(서브쿼리)
					
					b . 사용법
							
							1 ) 커서열기 (open)
							
								...커서의 열기는 open문을 사용
								
								...커서에서 검색이 실행되면 데이터가 추출되지 않아도 에러는 발생하지 않는다.
								
								...문법 : open 커서명
								
							2 ) 커서패치 (fetch)
							
								...커서의 fetch는 현재 데이터행을 output변수에 반환
								
								...커서의 select문의 컬럼갯수와 output변수의 갯수가 동수이어야한다.
								
								...커서컬럼의 타입과 output변수의 타입은 동일해야 한다.
								
								...문법 : fetch 커서명 into 변수1...변수n
								
							3 ) 커서닫기 (close)
							
								...사용이 끝난 커서는 반드시 닫아 주어야 한다.
								
								...커서를 닫은 경우에는 fetch할 수 없다.
								
								...필요한 경우에는 커서를 다시 open할 수 있다.
								
								...문법 : close 커서명
			
							
	
*/

-- 1 . 묵시적 커서
--사원번호를 전달받아서 사원의 유무여부를 리턴하는 프로시져 작성
create or replace procedure pro_19(p_empno in emp.empno%type) is
v_ename emp.ename%type;
v_sal emp.sal%type;
v_row number;
begin
 select ename, sal
 into v_ename, v_sal
 from emp
where empno = p_empno;

	-- 1 . 자료가 있는 경우, 없는 경우
	--sql%found / sql%notfound
		if sql%found
		then dbms_output.put_line(v_ename || '의 급여는' || v_sal || '원 입니다');
		else dbms_output.put_line(p_empno || '사원번호는 존재하지 않습니다');
		end if;
	-- 2 . 데이터행의 갯수
	update emp
		set comm = 0
		where empno = p_empno;

	
	v_row := sql%rowcount;
	dbms_output.put_line('급여가 수정된 사원의 수 =' || v_row);
	
exception when no_data_found then
	dbms_output.put_line('Exception : 사원자료가 없습니다');
end pro_19;



call pro_19(7369);
call pro_19(9999);



-- 명시적커서
-- 1) 한건만 처리 : 특정부서의 평균급여와 사원수를 출력
create or replace procedure pro_20(p_deptno in dept.deptno%type) is
-- 1. 커서선언
	cursor avg_by_dept is
	select dpt.dname
	     , count(emp.empno)
			 , round(avg(emp.sal), 0)
	  from emp emp, dept dpt
	 where emp.deptno = p_deptno
	   and emp.deptno = dpt.deptno
	 group by dpt.dname;
	 
-- 변수선언
	v_dname  dept.dname%type;
	v_cnt    number;
	v_avg    number;
begin
-- 2. 커서열기
	open avg_by_dept;

-- 3. 커서fetch
	fetch avg_by_dept into v_dname, v_cnt, v_avg;
	dbms_output.put_line('부서명 = ' || v_dname || ', 사원수 = ' || v_cnt || ', 평균급여 = ' || v_avg);
	
-- 4. 커서닫기
	close avg_by_dept;
	
exception when others then
		dbms_output.put_line('Exception: 부서번호가 없습니다!!!');
end pro_20;

call pro_20(10);

-- 2 ) 여러건
-- for문을 사용하면 거의 open, fetch, close가 자동으로 실행되기 때문에
-- 별도로 기술할 필요가 없고 레코드이름도 자동으로 선언되기 때문에 별도로
-- 선언할 필요가 없다.
-- for 레코드명 in 커서명 loop
--		자동으로 open, fetch
-- end loop
-- 부서별 인원수와 급여합계를 출력
create or replace procedure pro_21 is
cursor sum_by_dept is 
select dpt.dname		부서이름
			,count(emp.empno) 사원수
			,sum(emp.sal)		급여합계
from emp emp, dept dpt
where emp.deptno = dpt.deptno
group by dpt.dname;
begin
 for dept_list in sum_by_dept loop
 dbms_output.put_line('부서명 =' || dept_list.부서이름 ||
											',사원수 =' || dept_list.사원수 || 
											',평균급여 =' || dept_list.급여합계);
 end loop;
end pro_21;

call pro_21();




-- 3 . 명시적커서 속성 사용하기
create or replace procedure pro_22 is
cursor emp_list is
select empno, ename, sal
from emp;

v_empno emp.empno%type;
v_ename emp.ename%type;
v_sal   emp.sal%type;
begin
open emp_list;

loop
fetch emp_list into v_empno,v_ename,v_sal;
exit when emp_list%notfound;
dbms_output.put_line('사원번호 =' || v_empno || '사원이름=' || v_ename || '사원급여 =' || v_sal);
end loop;

dbms_output.put_line('전체 사원수' || emp_list%rowcount);

close emp_list;
exception when others then
	dbms_output.put_line('예외가 발생했습니다.');
end pro_22;




call pro_22();


-- 4 . 매개변수가 있는 커서 사용하기
-- 커서가 오픈된 후 질의가 실행되면 매개변수값을 커서에 전달할 수가 있다.
-- 부서번호를 전달 받아서 해당 부서 사원이름을 출력
create or replace procedure pro_23(p_deptno in dept.deptno%type) is
	cursor c_emplist(v_deptno in dept.deptno%type) is
	select ename 
	  from emp
	 where deptno = v_deptno;
	
begin

	dbms_output.put_line(p_deptno || '부서의 사원명부');
	dbms_output.put_line('-----------------------');
	
	for emplist in c_emplist(p_deptno) loop
		dbms_output.put_line('사원이름 = ' || emplist.ename);
	end loop;
	
exception when others then
		dbms_output.put_line('예외가 발생했습니다!!!');
		
end pro_23;






-- 5 . 커서를 이용해서 데이터의 행을 수정하거나 삭제하기
-- "where current of" 명령
-- 1) 특정조건을 사용하지 않고도 현재 참조된 자료의 행을 수정하거나 삭제할 수 있다.
-- 2) fetch문으로 최근에 사용된 행을 참조하기 위해 사용되는 명령
-- 3) delete, update를 사용할 수 있다.
-- 4) "where current of" 명령을 사용할 때 참조하는 커서가 있어야 하고
--		 for update절이 커서선언안에 정의되어 있어야 한다. 없으면 에러가 발생
--  7369사원의 급여를 800으로 수정
create or replace procedure pro_24 is
cursor c_emp is
select empno
			,ename
			,sal
		from emp
		where empno = 7369
		for update; -- 커서가 오픈될때 해당 레코드를 lock를 걸어놓는다. 커서가 close되면 unlock;
begin

for l_emp in c_emp loop
update emp
	set sal = 800
	where current of c_emp;
end loop;
exception when others then
	dbms_output.put_line('예외가 발생했습니다.');
end pro_24;



call pro_24();
select empno,ename,sal from emp where empno = 7369;


-- 실습 1 .성적관리 프로그램(pl/sql)
--테이블

create table sungjuk(
         hakbun  varchar2(10)
      , name    varchar2(10)
      , kor     number(3)
      , eng     number(3)
      , mat     number(3)
);
insert into sungjuk values(1001, '홍길동', 90,80,70);
insert into sungjuk values(1002, '홍길순', 100,100,100);
insert into sungjuk values(1003, '홍길자', 90,85,70);
insert into sungjuk values(1004, '홍길녀', 70,60,50);
insert into sungjuk values(1005, '홍길영', 40,50,70);
select * from sungjuk;

-- 성적결과 테이블
drop table sungresult;
create table sungresult(
         hakbun  varchar2(10)
      , name    varchar2(10)
      , kor     number(3)
      , eng     number(3)
      , mat     number(3)
      , tot     number(3)
      , avg     number(4,1)
      , hak     varchar2(2) -- A+ ~ F
      , pass    varchar2(10)
      , rank    number
);
select * from sungresult;


-- 1. sungjuk파일을    커서 c_sungjuk    로 정의
-- 2. sungresult파일을 커서 c_sungresult
-- 3. >=95 A+, >=90 A0, >=85 B+ 5점단위... >= 60 D0 else 'F
-- 4. 성적의 평균이 >= 70 pass= 'pass' else pass='fail';
-- 5. insert into sungresult() value()
-- 6. update sungresult rank = 순위를 update select count(*) + 1 from sungresult where tot > 180;


create or replace procedure pro_25 is

  cursor c_sungjuk is
    select hakbun, name, kor, eng, mat
    from sungjuk;
  
  cursor c_sungresult is
    select hakbun, name, kor, eng, mat, tot, avg, hak, pass, rank
    from sungresult;

  v_tot number(3);
  v_avg number(4,1);
  v_hak varchar2(2);
  v_pass varchar2(10);
  
begin

  for rec in c_sungjuk loop
  
    v_tot := rec.kor + rec.eng + rec.mat;
    v_avg := v_tot / 3.0;
    
    if v_avg >= 95 then
      v_hak := 'A+';
    elsif v_avg >= 90 then
      v_hak := 'A0';
    elsif v_avg >= 85 then
      v_hak := 'B+';
    elsif v_avg >=80 then
      v_hak := 'B0';
		elsif v_avg >=75 then
      v_hak := 'C+';
		elsif v_avg >=70 then
      v_hak := 'C0';
		elsif v_avg >=65 then
      v_hak := 'D+';
		else
      v_hak := 'F';
    end if;
    
    if v_avg >= 70 then
      v_pass := 'pass';
    else
      v_pass := 'fail';
    end if;
    
    insert into sungresult values (rec.hakbun, rec.name, rec.kor, rec.eng, rec.mat, v_tot, v_avg, v_hak, v_pass, null);
      
  end loop;
  
  update sungresult t1
  set rank = (select count(*) + 1 from sungresult t2 where t1.tot < t2.tot);
  
exception 
  when others then
    dbms_output.put_line('예외가 발생했습니다.');
    
end pro_25;



SELECT * FROM sungresult;

