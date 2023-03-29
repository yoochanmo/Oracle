/*
	A . Where 조건절
	
	1 . 비교연산자
			=, !=, <>, >, >=, <, <= 
	
	2 . 기타연산자
			a and b : 논리곱
			a OR b	: 논리합
			not a   : 부정
			between A and B : a와 b사이의 데이터를 검색 , a는 b보다 작은 값으로 정의
			in(a, b, c....) : a,b,c..의 값을 가지고 있는 데이터를 검색
			like (%, _와 같이 사용) : 특정 패턴을 가지고 있는 데이터를 검색
					-> '%A' 끝이 A로 끝나는 데이터, 'A%' A로 시작, '%A%' A를 포함
				is null/ is not null : null값 여부를 가지고 있는 데이터를 검색
				
*/

/*A. 비교연산자*/
-- 1. 급여(sal)가 5000인 사원 조회하기
SELECT * FROM emp;
SELECT * FROM emp WHERE sal = 5000;
SELECT * FROM emp WHERE sal = 1600;


-- 2. 급여가 900보다 작은 사원
SELECT * FROM emp WHERE sal < 900;
SELECT * FROM emp WHERE sal > 900;


-- 3. 이름이 스미스인 사원 조회

SELECT * FROM emp WHERE ENAME = 'SMITH';
SELECT * FROM emp WHERE ENAME = SMITH; --(x) 스미스는 열이름으로 인식


-- 대소문자변환함수 upper(), lower()
SELECT * FROM emp WHERE ENAME = 'SMITH';
SELECT ENAME FROM EMP WHERE ENAME = upper('smith'); --바람직하지 않음
SELECT ENAME FROM EMP WHERE LOWER(ENAME) = 'smith'; -- 바람직하지 않음


-- 4 . 입사일자(hiredate)
-- 입사일자가 1980-12-17인 사원을 조회
-- 힌트 : data타입은 비교할 때 문자열로 간주
SELECT * FROM emp;
SELECT * FROM EMP WHERE HIREDATE = '1980-12-17';











