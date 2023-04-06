/*
	FUNCTION?
	
		1 . FUNCTION
		
				보통의 경우 값을 계산하고 그 결과를 반환하기 위해서 function을 사용한다.
				대부분 procedure와 유사하지만
				
				1) in 파라미터만 사용할 수 있다.
				2) 반드시 반환될 값의 데이터 타입을 return문안에 선언해야한다.
				
	
		2 . 문법
		
				1) pl/sql 블럭안에는 적어도 한개의 return문이 있어야한다.
				2) 선언방법
				
						create or replace function 펑션이름(arg1 in 데이터타입,...)
						return 데이터타입 is[as]
							변수선언...
						[pragma autonomous_transaction]	 -- <-- DML을 사용할 경우
						begin
						end 펑션이름;
						
						
		3 . 주의사항
		
				오라클함수 즉, function에서는 기본적으로 DML(insert,update,delete)문을 사용할 수 없다.
				만약에 사용하고자 할 경우 begin 바로 위에 pragma autonomous_transaction을 선언하면 사용
				할 수 있다.
				
				
		4 . procedure vs function
		 
				procedure                                   function
		---------------------------                ----------------------
		 서버에서 실행(속도가 빠름)                          		클라이언트에서 실행
		 return값이 있어도 되고 없어도 된다.                 	  return값이 필수
		 return값이 여러개(out 여러개)                       return값이 하나만 가능
		 파라미터는 in,out으로 처리                           in만 있다.
		 select 절에는 사용불가                             select에서 사용가능
			-->call, execute                                --> select 펑션() from dual;
*/

	--실습 1 . 사원번호를 입력받아서 급여를 10%인상하는 함수작성
	create or replace function fn_01(p_empno in number) return number is
	v_sal number;
	pragma autonomous_transaction;
	begin
	update emp
	set sal = sal * 1.1
	where empno = p_empno;
	commit;
	
	select sal
		into v_sal
		from emp
		where empno = p_empno;
		
		return v_sal;
	end fn_01;
	
	--call fn_01(7369);
	select sum(sal) from emp;
	select fn_01(7369) from dual;
	
	--call fn_01(7369) PROCEDURE는 call로 호출이 가능하지만 FUNCTION 할 수 없다.


	
	
	-- 실습 2 . 부피를 계산하는 함수 fn_02
	-- 부피 = 길이 * 넓이 * 높이
	create or replace function fn_02(p_length in number,p_width in number, p_height in number) return number is
	v_result number;
	begin
	v_result := p_length * p_width * p_height;
	return v_result;
	end fn_02;
	select fn_02(10,10,10) from dual;
	
	
	--실습3 . 현재일을 입력받아서 해당월의 마지막일자를 구하는 함수
	create or replace function fn_03(v_date in date) return date is
	lastdate date;
	begin
	lastdate := ADD_MONTHS(v_date, 1) - TO_CHAR(v_date,'dd');
	return lastdate;
	end fn_03;
	
	select fn_03(sysdate) from dual;
	
	
	--실습 4 . '홍길동' 문자열을 전달받아서 '길동'만 리턴하는 함수
	create or replace function fn_04(p_name in varchar2) return varchar2 is
	f_name varchar2(10);
	begin
	f_name := substr(p_name,2);
	return f_name;
	end fn_04;
	
	SELECT fn_04('선우용녀') from dual;
	SELECT ename,fn_04(ename) FROM emp;
	
	
	-- 실습 5 . fn_05 현재일 입력받아서 '2023년 04월 03일의 형태로 리턴
	create or replace function fn_05(t_date in date) return varchar2 is
	to_date VARCHAR2(30);
	begin
	to_date := to_char(t_date, 'yyyy"년" mm"월"dd"일"');
	return to_date;
	end fn_05;
	
	
	SELECT fn_05(sysdate) FROM dual;
	SELECT NAME, fn_05(hiredate) FROM PROFESSOR;
	
	
	--실습 06 . fn_06 ssn(주민) 번호를 입력받아서 남자 or 여자인지 리턴하는 함수
	create or replace function fn_06(p_jumin in varchar2) return varchar2 is
	gender varchar2(10);
	begin
	gender := SUBSTR(p_jumin,7,1);
	IF gender in ('1','3') 
	then gender := '남자';
	else gender := '여자';
	end if;
	return gender;
	end fn_06;
	
	SELECT JUMIN FROM STUDENT;
	SELECT fn_06('7510231901813') from dual UNION ALL
	SELECT fn_06('7510232901813') from dual;
	
	SELECT name,fn_06(JUMIN),fn_05(birthday) FROM STUDENT;
	
	SELECT * FROM STUDENT;
	
	
	
	-- 실습 07 . fn_07 PROFESSOR HIREDATE 를 읽어서 현재일기준으로 근속연월 계산
	-- 					근속년 floor(), 근속월ceil() -> 12년 5개월 개노예
	create or replace function fn_07(noye varchar2) return varchar2 is
	gunmu varchar2(20);
	begin
	gunmu := floor(MONTHS_BETWEEN(SYSDATE, noye)/12) || '년' ||
					 floor(MOD(MONTHS_BETWEEN(SYSDATE, noye), 12)) || '개월'||'노예';
  return gunmu;
	
	end fn_07;
	
	
	
	SELECT name,hiredate,fn_07(hiredate) from professor;
	SELECT ename,hiredate,fn_07(hiredate) from emp;
	
	SELECT fn_07('20190221') from dual;
	
	
	
	
	
	
	
	
	
	
	
	SELECT * FROM PROFESSOR;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	