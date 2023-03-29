/*
	sub query
	
	1 . Main Query와 반대되는 개념으로 이름을 부여한 것
	2 . 메인쿼리를 구성하는 소단위 쿼리(종속쿼리)
	3 . subquery 안에는 select,insert,delete,update 모두 사용이 가능하다.
	4 . subquery의 결과값을 메인쿼리가 사용하는 중간값으로 사용할 수 있다.
	5 . subquery 자체는 일반 쿼리와 다를 바가 없다.
	
	서브쿼리의 종류
	
	1 . 연관성에 따른 분류
			a . 연관성이 있는 쿼리
			b . 연관성이 없는 쿼리
			
			
	2 . 위치에 따른 분류
			a . inline view : select절이나 from절안에 위치하는 쿼리
			b . 중첩쿼리				: where절에 위치한 쿼리
			
			제약사항
			
			1 . where 절에 연산자 오른쪽에 위치해야 하며 반드시 소괄호()로 묶어야한다.
			2 . 특수한 경우를 제외하고는 subquery절에는 order by를 사용할 수 없다.
			3 . 비교연산자에 따라서 단일행 subquery(<,>,=...), 다중행 subquery(in,exits..)를
					사용할 수 있다.
*/
/* A . 다른 사용사즤 객체(table,view...)에 접근권한 부여하기*/
-- 1. 현재 scott은 hr의 테이블에 접근할 수 있는 권한이 없다.
SELECT * FROM hr.employees; --ORA-01031: insufficient privileges

-- 2 . hr 사용자가 scott에게 employees, departments에 조회권한 부여하기
-- 1) sysdba권한 or 소유자(hr)가 다른 사용자(scott)에게 권한을 부여할 수 있다.
-- 2) hr에서 scott에 권한을 부여 
-- 3) 사용자를 hr로 변경후에 작업 할 것
-- 4) 문법 :  a . 권한부여 : GRANT 부여할 명령 ON 접근허용할 객체 to 권한부여하는사용자
--					 b . 권한해제 : revoke 해제할 명령 on 해제할 객체 from 권한해제할사용자

--권한부여
GRANT SELECT ON EMPLOYEES TO scott;
GRANT SELECT ON DEPARTMENTS TO scott;

SELECT * FROM hr.employees;
SELECT * FROM hr.DEPARTMENTs;
SELECT * FROM hr.countries; --ORA-01031: insufficient privileges 권한이 없음.


--권한해제(hr계정으로)
REVOKE SELECT on EMPLOYEES from scott;
REVOKE SELECT on DEPARTMENTS from scott;


-- 3 . scott에 select 권한을 받은 테이블 조회하기
-- 다른 사용자(스키마)의 객체에 접근하려면 '스키마.객체이름' 형식으로 접근해야한다.

SELECT * FROM hr.employees;
SELECT * FROM hr.DEPARTMENTS;


/* B . 단일행 sub query*/
-- 실습 1 . 샤론스톤과 동일한 직급(instructor)인 교수들을 조회하기

SELECT * FROM scott.PROFESSOR;

SELECT POSITION FROM PROFESSOR WHERE POSITION = 'instructor';
SELECT POSITION FROM PROFESSOR WHERE name = 'Sharon Stone';


SELECT * 
FROM PROFESSOR
WHERE POSITION = (SELECT POSITION FROM PROFESSOR WHERE name = 'Sharon Stone');


-- 실습 2 . hr에서 employees, departments를 join해서
-- 사원이름 (first_name + last_name), 부서ID, 부서명(inline view)를 조회하기

SELECT * FROM hr.employees;
SELECT * FROM hr.DEPARTMENTS;


			


select first_name || '.' || last_name 사원명
     , emp.department_id              부서명
		 , (select department_name 
		      from hr.departments dpt 
		     where emp.department_id = dpt.department_id) 부서이름
  from hr.employees emp;












