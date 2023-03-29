/*
	 View란?
	 
	 1 . view란 가상의 테이블이다.
	 2 . view에는 실제 데이터가 존재하지 않고 view를 통해서 데이터만 조회할 수 있다.
	 3 . view는 복잡한 query를 통해 조회할 수 있는 결과를 사전에 정의한 view를 통해
				간단히 조회할 수 있게 한다.
	 4 . 한개의 view로 여러 개의 Table데이터를 검색할 수 있게 한다.
	 5 . 특정 기준에 따라 사용자별로 다른 조회 결과를 얻을 수 있게 한다.
	 
	 view의 제한조건
	 
	 1 . 테이블에 not null로 만든 컬럼들이 view에 포함되어야 한다.
	 2 . view를 통해서도 데이터를 insert할 수 있다. 단,rowid, rownum, nextval, curval
				등과 같은 가상의 컬럼에 대해 참조하고 있을 경우에 가능하다.
	 3 . with read only 옵션으로 설정된 view는 어떠한 데이터를 갱신할 수 없다.
	 4 . with check option을 설정한 view는 view조건에 해당되는 데이터만 삽입,삭제,수정
				할 수 있다.
				
		view 문법
		
		CREATE [OR REPLACE] [force || noforce] VIEW 뷰이름 as
		sub query...
		with read only
		with check option
		
		1 . or replace : 동일 이름의 view가 존재할 경우 삭제후 다시 생성(대체)
		2 . force || noforce : 테이블의 존재유무와 상관없이 view를 생성할지 여부
		3 . with read only : 조회만 가능한 view
		4 . with check option : 주어진 check 옵션 즉, 제약조건에 맞는 데이터만 입력하거나 수정가능
		
		view 조회방법
		
		테이블과 동일한 문법으로 사용
		
		view를 생성할 수 있는 권한 부여하기
		
		1 . 사용자권한 조회  : SELECT * FROM user_role_privs;
		2 . 권한 부여 			 : sysdba에 권한으로 부여가능
					GRANT CREATE VIEW TO SCOTT(사용자 계정 or schema)
*/

SELECT * FROM EMP;


CREATE or REPLACE VIEW v_emp as 
SELECT ENAME,JOB,DEPTNO FROM EMP; -- ORA-01031: insufficient privileges 권한이 없다.

-- 1 . create view 권한 부여하기
--grant CONNECT, resource to scott;
GRANT CREATE VIEW to scott;

-- 2 . 권한 조회
SELECT * from user_role_privs;


-- 3 . 단순 view 생성하기
CREATE or REPLACE VIEW v_emp as 
SELECT ENAME,JOB,DEPTNO FROM EMP;

SELECT * FROM v_emp;

-- 4 . 사용자 view목록 조회하기
SELECT * FROM user_views;


SELECT * FROM EMP;
SELECT * FROM Dept;

-- 5 . 복합 VIEW
CREATE or replace view v_emp_dname as
SELECT EMP.ename,DPT.DNAME,DPT.DEPTNO
FROM EMP EMP, DEPT DPT
WHERE EMP.DEPTNO = DPT.DEPTNO;

SELECT * FROM v_emp_dname;



-- 실습. 급여(sal,comm)가 포함된 view
-- 예) 급여조회권한이 있는 담당자만 사용할 수 있는 view
CREATE OR REPLACE VIEW v_emp_sal as
SELECT EMPNO 사원번호
			,ENAME 사원이름
			,JOB 직급
			,SAL 급여
			,nvl(comm,0) 커미션
		FROM EMP;

SELECT * FROM v_emp_sal;


SELECT * FROM v_emp_sal WHERE JOB ='CLERK';
SELECT * FROM v_emp_sal WHERE 직급 ='CLERK';



SELECT *
 FROM (SELECT EMPNO 사원번호
			,ENAME 사원이름
			,JOB 직급
			,SAL 급여
			,nvl(comm,0) 커미션
		FROM EMP)
	WHERE job = 'CLERK'; --ORA-00904: "JOB": invalid identifier

SELECT *
 FROM (SELECT EMPNO 사원번호
			,ENAME 사원이름
			,JOB 직급
			,SAL 급여
			,nvl(comm,0) 커미션
		FROM EMP)
	WHERE 직급 = 'CLERK';


-- 6 . table과 view의 join?
SELECT EMP.DEPTNO,v_emp.*
	FROM EMP EMP, v_emp_sal v_emp
	WHERE EMP.EMPNO = v_emp.사원번호;


CREATE OR REPLACE VIEW v_test as
SELECT EMP.DEPTNO,v_emp.*
	FROM EMP EMP, v_emp_sal v_emp
	WHERE EMP.EMPNO = v_emp.사원번호;

SELECT * FROM v_test;


--실습 . emp에서 부서번호 , dept에서 dname,v_emp_sal와 join
--			사원번호,사원이름,부서명,직급,급여 출력할 수 있는 join 쿼리
SELECT * FROM v_emp_sal;
SELECT * FROM emp;
SELECT * FROM DEPT;


CREATE OR REPLACE VIEW v_test2 as
SELECT EMP.DEPTNO
			,DPT.DNAME
			,SAL.*
		FROM EMP EMP
		,DEPT DPT
		,V_EMP_SAL SAL
WHERE EMP.DEPTNO = DPT.DEPTNO
AND EMP.EMPNO = SAL.사원번호;


SELECT * FROM v_test2;


--7 . inline view
-- 제약사항 : 한 개의 컬럼만 정의할 수 있다.

SELECT EMP.ENAME
			,DPT.DNAME
FROM EMP EMP
		,DEPT DPT
WHERE EMP.DEPTNO = DPT.DEPTNO;


SELECT EMP.ENAME
			,(SELECT DNAME FROM DEPT DPT WHERE EMP.DEPTNO = DPT.DEPTNO )
FROM EMP EMP; -- 한개의 컬럼만 가능.


SELECT EMP.ENAME
			, DPT.DNAME 부서번호
			FROM EMP EMP; 
			,(SELECT DNAME FROM DEPT DPT) DPT
			 WHERE EMP.DEPTNO = DPT.DEPTNO;



-- 8 . view 삭제하기
DROP VIEW v_test2;
SELECT * FROM user_views;


-- 실습. emp와 dept를 조회 : 부서번호와 부서별최대급여 및 부서명을 조회
-- 1) view를 생성
CREATE or REPLACE VIEW v_max_sal_01 as 
SELECT EMP.DEPTNO,EMP.SAL, DEPT.DNAME 
FROM EMP EMP, DEPT DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;

SELECT * FROM v_max_sal_01;

-- 2) inline view로 작성

--deptno,dname,max_sal : 

-- view이름 : v_max_sal_01
CREATE or REPLACE VIEW v_max_sal_02 as 
SELECT DEPTNO
			,MAX(SAL) 최대급여
			FROM EMP
			GROUP BY DEPTNO
			ORDER BY DEPTNO;

SELECT * FROM v_max_sal_02;

SELECT d.deptno
			,d.dname
			,m.최대급여
FROM dept d
			,v_max_sal_02 m
	WHERE d.deptno = m.deptno;



SELECT emp.deptno 부서번호
			,dpt.dname 부서이름
			,max(sal) 최대급여
	FROM emp emp
			,dept dpt
	where emp.deptno = dpt.deptno
	GROUP BY emp.deptno, dpt.dname
	ORDER BY emp.deptno;


-- inline view (inline view에 GROUP BY 사용)

CREATE or REPLACE VIEW v_max_sal_03 as 
SELECT dpt.deptno
			,dpt.dname
			,sal.max_sal
	FROM dept dpt
			,(select deptno, sum(sal) as max_sal from emp group by deptno) sal
WHERE dpt.deptno = sal.deptno;

SELECT * FROM v_max_sal_03;




--inline view 
CREATE or REPLACE VIEW v_max_sal_04 as

SELECT dpt.deptno
			,dpt.dname
			,(select max(sal) from emp emp where dpt.deptno = emp.deptno group by deptno)
			from dept dpt;







