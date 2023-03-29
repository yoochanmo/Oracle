/*
	DML
		1. insert : 테이블에 데이터를 추가
		2. update	: 테이블에 데이터를 수정
		3. delete	: 테이블에 데이터를 삭제
		4. merge	: 2개 이상의 테이블을 한개의 테이블로 병합
		

	
		A . insert
		
			1 . 테이블에 새로운 행(row,record)를 추가할 때 사용하는 명령
			2 . 테이블에 새로운 데이터를 입력(추가)하기 위한 데이터조작어
			3 . 문법
					
					1) insert into 테이블명 (컬럼1...컬럼n) values(값1...값n);
					2) insert into 테이블명 values(값1...값n);
					3) 서브쿼리를 이용해서 기존 테이블에 데이터를 추가하는 방법
							...insert into 테이블명 select 컬럼1...컬럼n 테이블명 where...
							... 동일갯수, 동일순서, 동일데이터타입일 경우 사용가능
					4) insert all
										when 조건 then into 
										when 조건 then into
										
					5) insert all
										into 테이블명 values()
										into 테이블명 values()
	
	
*/
-- 1 . 레코드 추가
-- 실습1. dept2의 부서번호 9000, 부서명 테스트부서_1, 상위부서=1006, 지역= 기타지역 
INSERT INTO DEPT2(DCODE,DNAME,PDEPT,AREA) VALUES (9000,'test',1006,'etc');
INSERT INTO DEPT2(DCODE,DNAME,PDEPT,AREA) VALUES (9001,'test2',1006,'etc');
INSERT INTO DEPT2(DCODE,DNAME,PDEPT,AREA) VALUES (9001,'test3',1006,'etc'); --unique constraint (SCOTT.SYS_C007018) violated
select * from dept2;


-- 실습 2  PROFESSOR에 교수번호 5001, 교수명 고길동 교수 id GO , POSITION=정교수 , 급여 =510, 입사일 오늘

insert into PROFESSOR(PROFNO,NAME,ID,POSITION,PAY,HIREDATE) VALUES(5001,'고길동','Go','정교수',510,SYSDATE);

SELECT*FROM PROFESSOR;

-- 실습 3 . 
-- 1) PROFESSOR의 구조만 복사해서 PROFESSOR4로 만들고
-- 2) PROFESSOR중에서 PROFNO가 4000보다 큰교수만 PROFESSOR4에 추가

drop table PROFESSOR4;
create table PROFESSOR4 as select * from PROFESSOR where PROFNO > 4000;

SELECT * FROM PROFESSOR4;


-- 실습 4 . 
-- PROFESSOR를 기준으로 prof_3과 prof_4를 테이블 생성
-- 1) 각각 profno number, name varchar2(25)의 2개의 컬럼만 존재하는 테이블 생성
-- 2) prof-3에는 1000 ~ 1999번까지의 교수만
-- 3) prof-4에는 2000 ~ 2999번까지의 교수만 복사
CREATE table prof_3 (profno number, name VARCHAR2(25));
CREATE TABLE prof_4 as SELECT * FROM prof_3 where 1=2;

insert into prof_3 SELECT profno, name FROM PROFESSOR WHERE PROFNO BETWEEN 1000 and 1999;
insert into prof_4 SELECT profno, name FROM PROFESSOR WHERE PROFNO BETWEEN 2000 and 2999;

SELECT * FROM prof_3;
SELECT * FROM prof_4;



-- 2 . insert all(1)
DROP table prof_3;
DROP table prof_4;

CREATE table prof_3 (profno number, name VARCHAR2(25));
CREATE TABLE prof_4 as SELECT * FROM prof_3 where 1=2;

INSERT ALL 
		WHEN profno BETWEEN 1000 and 1999 then into prof_3 VALUES(profno,name)
		WHEN profno BETWEEN 2000 and 2999 then into prof_4 VALUES(profno,name)
SELECT * FROM PROFESSOR;

SELECT * FROM prof_3;
SELECT * FROM prof_4;

-- 3 . insert all(2)
-- 동일자료를 각각 다른 테이블에 추가하는 방법 

INSERT all
	INTO prof_3
	into prof_4
SELECT profno, name FROM PROFESSOR
where profno BETWEEN 3000 and 3999 ;


SELECT * FROM prof_3;
SELECT * FROM prof_4;




/*
	B . update
	
		1 . 테이블에 있는 데이터를 수정하기 위해서 사용되는 명령
		2 . 기존의 행 or 열을 수정하기 위해서 사용
		3 . 주의할 점 where 조건절에 특정의 조건을 정의하지 않을 경우 전체 데이터가 수정이 된다.
		4 . 문법
			
				update 테이블명
					set 컬럼 = 값
					where 조건절;
*/
drop table emp999;
create table emp999 as select * from emp;
SELECT * FROM emp999;

--UPDATE 주의할 점
UPDATE emp999
SET ename = '스미스'; -- 다 스미스로 바뀜

SELECT * FROM emp999;

-- 1 . 전체 사원의 부서번호를 10, 급여를 0으로 수정
UPDATE emp999
SET deptno = 10,
		sal = 0;
SELECT * FROM emp999;

drop table emp999;
create table emp999 as select * from emp;
SELECT * FROM emp999;


-- 실습. 전체사원의 급여를 10% 인상
UPDATE emp999
SET sal = sal*1.1;

SELECT * FROM emp999;

-- 실습 2 . 모든 사원의 입사일 현재일로 수정
UPDATE emp999
set HIREDATE = SYSDATE;
SELECT * FROM emp999;


-- 실습 3 . PROFESSOR에서 직급이 assistant PROFESSOR 인 사람의 보너스를 200으로 인상히기
create table PROFESSOR5 as select * from PROFESSOR;
SELECT * FROM PROFESSOR5;

UPDATE PROFESSOR5 
SET BONUS = BONUS+200
WHERE POSITION = 'assistant professor';

-- 실습 4 . PROFESSOR에서 sharon stone과 직급이 동일한 교수들의 급여를 15%인상하기

UPDATE PROFESSOR5
SET PAY = PAY * 1.15
WHERE POSITION = (SELECT POSITION FROM PROFESSOR5 WHERE NAME ='Sharon Stone');

SELECT * FROM PROFESSOR5;



/*
		C . delete
		
		1 . 테이블에서 특정 조건의 자료를 삭제
		2 . 행단위로 삭제(열만 삭제할 수 없다)
		3 . 문법
		
			delete form 테이블명
			where 조건절;

*/

select * from professor5;
delete from professor5;

create table PROFESSOR6 as select * from PROFESSOR;
SELECT * FROM PROFESSOR6;

select * FROM dept2;
 
-- 실습 부서코드가 9000이상인 자료를 삭제
DELETE FROM DEPT2
WHERE DCODE = 9000;

-- 실습 부서코드가 9000이상인 자료를 삭제
DELETE FROM DEPT2
WHERE DCODE >= 9000;


/*
	D . merge
	
	1 . 여러개의 테이블을 한 개의 테이블로 병합하는 명령
	2 . 문법
			
			merge into 병합할 테이블명
				using 테이블1 on 병합할 조건 
				when matched then update set 업데이트할 명령
						delete where 조건절
						 when not matched then insert into values(...);
				
*/
CREATE table charge_01(
	u_date 	 varchar2(6)
	,cust_no NUMBER
	,u_time  NUMBER
	,charge  NUMBER
);

CREATE table charge_02(
	u_date 	 varchar2(6)
	,cust_no NUMBER
	,u_time  NUMBER
	,charge  NUMBER
);

CREATE table charge_03(
	u_date 	 varchar2(6)
	,cust_no NUMBER
	,u_time  NUMBER
	,charge  NUMBER
);


SELECT * FROM tab;


insert into charge_01 values('141001',1000,2,1000);
insert into charge_01 values('141001',1001,2,1000);
insert into charge_01 values('141001',1002,1,1000);


insert into charge_02 values('141002',1000,3,1500);
insert into charge_02 values('141002',1001,4,2000);
insert into charge_02 values('141002',1003,1,500);


SELECT * FROM charge_01
UNION ALL
SELECT * FROM charge_02;



SELECT * FROM charge_03;


-- 1 . charge_01 + charge_03
merge into charge_03 tot
	using charge_01 c01 on (tot.u_date = c01.u_date)
	when matched then update set tot.cust_no = c01.cust_no
	when not matched then insert values(c01.u_date,c01.cust_no,c01.u_time,c01.charge);


-- 2 . charge02 + charge03
merge into charge_03 tot
using charge_02 c02 on (tot.u_date = c02.u_date)
when        matched then update set tot.cust_no = c02.cust_no
when not matched then insert values(c02.u_date,c02.cust_no,c02.u_time,c02.charge);

SELECT * FROM charge_03;



/*
	E . transaction
	
	
	실무에서는 간단한 sql 작업을 하는 것이 아니라 대부분이 여러가지 작업을 동시에 처리하게 되는데
	처리 도중에 에러가 발생되는 경우에는 이전 실행 작업을 취소해야 할 필요가 있게 된다.
	에러가 없을 경우에는 최종적으로 작업을 확정하게 되는데 이런 작업을 취소 or 확정하게 하는 명령이
	rollback, commit 이다.
	
	rollback : 확정되지 않은 이전 작업을 취소하는 명령
	commit : 작업을 최종적으로 확정하는 명령
	
	
*/


	--연습문제 
	--1.
	INSERT INTO DEPT2(DCODE,DNAME,PDEPT,AREA) VALUES (9010,'temp_10',1006,'temp area');
	SELECT * FROM dept2;
	--2.
	INSERT INTO DEPT2(DCODE,DNAME,PDEPT) VALUES (9020,'temp_20',1006);
	SELECT * FROM dept2;
	--3.
	CREATE TABLE PROFESSOR6 as SELECT PROFNO, NAME, PAY FROM PROFESSOR WHERE 1=2;
	INSERT INTO PROFESSOR6 SELECT PROFNO, NAME, PAY FROM PROFESSOR WHERE PROFNO <= 3000;
	SELECT * FROM PROFESSOR6;
	
	--4.
	UPDATE PROFESSOR
	SET BONUS = 100
	WHERE NAME = 'Sharon Stone';

	SELECT * FROM PROFESSOR;




















