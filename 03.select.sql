-- select 명령
-- 문법 : select [*|column명,,,]from [table | view] where 조건절
-- 데이터를 조회하는 명령
-- 실습 1. scott의 dept,emp 테이블내용 조회하기
--		 2. emp 테이블의 모든 컬럼 조회하기
--		 3. emp 에서 사원명과 사원번호만 조회하기
--		 4. 사용자생성하기 : scott대신에 your name, 비번은 12345
--		 5. 생성된 사용자에게 권한부여하기
--		 6. db 접속하기


--1.
select * from DEPT,EMP;
--2.
SELECT * from EMP;
--3.
SELECT ename, empno from emp;
--4
CREATE USER chanmo IDENTIFIED by 12345;





/*
SQL 문의 종류

1 . DML (Data Manipulation Language, 데이터조작어)
					1) select : 자료 조회
					2) insert : 자료를 추가
					3) delete : 자료 삭제
					4) update : 자료 수정
					5) commit : CUD등의 작업을 최종적으로 확정하는 명령
					6) rollback : CUD의 작업을 취소하는 명령
					
					* CRUD : Create, Read, Update, Delete)
					
2 . DDL	(Data Definition Language, 데이터정의어)
				-oracle 객체와 관련된 명령어
				-객체(Object)의 종류 : user, table, view, index...
					1) create : 오라클 DB객체를 생성
					2) drop	  : 오라클 DB객체를 삭제(객체까지 완전삭제)
					3) truncate : 오라클 DB객체를 삭제(객체는 남기고 데이터만 삭제)
					4) alter		: 오라클 DB객체를 수정
					
					
3 . DCL (Data Control Language, 데이터관리어)
				
					1) grant : 사용자에게 권한(or Role) 부여(connect, RESOURCE...
					2) revoke : 사용자의 권한(or role)을 취소
			
		B . select 문법
				
				select [distinct] {*,[coll[[as] 별칭],...coln[[as]별칭]}
					from [스키마].table명(view명, [select * from 테이블명])
					[where 조건절 [and, or, like, between...]]
					[order by 열이름(or 표현식) [asc/desc],...]
					
					
					1. distinct : 중복행이 있을 경우 중복제거를 하고 한 행만 조회
					2. *				: 객체의 모든 컬럼을 의미
					3. 별칭(alias) : 객체나 컬럼명을 별칭으로 정의
					4. WHERE		: 조건절에 만족하는 행만 출력 
					5. 조건절			: 컬럼, 표현식, 상수 및 비교연산(>,<,=,!..)
					6. ORDER BY : 질의(query)결과를 정렬(asc 오름차순(기본값),desc 내림차순)
*/

-- 1. 특정 테이블의 자료를 조회하기
SELECT * FROM tabs;
select * from emp;
select * from scott.emp;
select * from hr.emp;	--not exit;
select * from hr.employees;	--

select empno, ename, sal from emp;

--별칭
SELECT empno as 사원번호
			,ename 사원이름
			,sal "사원 급여"
			,sal payroll
			,sal 사원급여
			,sal 사원_급여
			,sal "사원_급여"
from emp;


-- 3. 표현식 : litral, 상수, 문자열 : 표현식은 작은 따옴표로 정의해야함.
SELECT ename from emp;
SELECT '사원이름 = ',ename from emp;
SELECT '사원이름 = '이름,ename from emp;
SELECT "사원이름 = ",ename from emp; --(x)큰 따옴표는 에러
SELECT '사원이름 = ',"ename" from emp; --(x) 컬럼이 큰 따옴표로 정의할 경우 대소문자 구분
SELECT '사원이름 = ',"ENAME" from emp; --(o)
SELECT '사원이름 = ',ENAME from emp;
SELECT '사원이름 = ',ENAME FROM emp;
SELECT '사원이름 = ',ENAME FROM "emp"; --(x) 

-- 4 . distinct 중복제거
SELECT * FROM emp;
SELECT DEPTNO from emp;
SELECT DISTINCT DEPTNO from emp; --디스팅트는 무조건 컬럼명 앞에 줘야함
SELECT DISTINCT DEPTNO, ename from emp;
SELECT DISTINCT DEPTNO DISTINCT ename from emp; --컬럼명 앞에 한번만 

-- 5 . 정렬 order by
SELECT * from emp;
SELECT * from emp order by ename;
SELECT * from emp order by ename asc;
SELECT * from emp order by 1; --2는 select절안에 컬럼의 위치를 의미
SELECT ename, empno from emp order by 1;
SELECT * from emp order by ename desc;

SELECT * from emp order by ename,HIREDATE desc, 6 desc; --복합순서로 정렬
SELECT * from emp order by 6 desc,HIREDATE desc, ENAME;

--실습 1. 부서번호, 직무를 조회하는데 중복제거
--		2. 중복제거후 부서, 직무순으로 정렬(asc,desc)
--		3. DEptno를 부서번호, job을 직급으로 별치로 정의


SELECT DISTINCT JOB,deptno FROM emp;

SELECT DISTINCT JOB,deptno
 FROM emp
 ORDER BY DEPTNO,JOB;

SELECT DISTINCT deptno as 부서번호,JOB 직급
 FROM emp
 ORDER BY 1,2;
 
 -- 6 . 별칭으로 열이름 부여하기
 SELECT ename FROM emp;
 SELECT '사원이름', ename FROM emp; --literal(문자열)은 하나의 열로 간주가 된다.
SELECT '사원이름', ename as 사원이름 FROM emp;
SELECT '사원이름', ename as 사원이름 FROM emp; --(x) 세 번째의 사원이름은 emp의 사원이름이란 열로 간주
SELECT '사원이름', ename as "사원이름" FROM emp; --(x)상기와 동일한 에러

SELECT '사원의 이름 =',ename from emp;
--SELECT '사원's=', ename from emp; --(x)작은 따옴표 or 큰 따옴표는 쌍으로 구성되어야 한다.
SELECT '사원''s이름=', ename from emp;

-- 7 . 컬럼 및 문자열 연결하기 : concat()함수 or || -> 연결자
SELECT ENAME, deptno from emp;
--smith(20) 형식으로 출력
-- 1) 연결연산자(||)
SELECT ename, '(',deptno,')' from emp;
SELECT ename || '('|| deptno ||')' "사원명과 부서 번호" from emp;

-- 2) concat(a,b)
SELECT CONCAT(ename,'('), CONCAT(DEPTNO, ')') "사원명과 부서번호" FROM emp;
SELECT CONCAT(CONCAT(ename, '('),CONCAT(DEPTNO,')')) "사원명과 부서번호" FROM emp;
SELECT CONCAT(ename, '(')|| CONCAT(DEPTNO,')') "사원명과 부서번호" FROM emp;



-- 실습. "smith의 부서는 20입니다" 형태로 출력하기
SELECT ename, DEPTNO from emp;
select ename || '의 부서는'|| DEPTNO ||'입니다' FROM emp;
SELECT CONCAT(CONCAT(ename,'의 부서는'),concat(deptno,'입니다')) as "사원명 and 부서번호" from emp;


/* 연습문제*/

-- 1. student에서 학생들의 정보를 이용해서 "Id and Weight" 형식으로 출력하세요
-- 2. emp에서 "Name and Job" 형식으로 출력
-- 3. emp에서 "Name and Sal"


-- 1. 
SELECT id || 'and' || weight FROM STUDENT;
SELECT ename || 'and' || JOB from emp ;
SELECT ename || 'and' || SAL from emp;








