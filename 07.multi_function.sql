/* 그룹함수 */

-- 1. count : 조건에 맞는 행의 갯수를 리턴
SELECT COUNT(*) FROM emp;
SELECT COUNT(ENAME) FROM emp;
SELECT COUNT(COMM) FROM emp;
SELECT COUNT(nvl(COMM,0)) FROM emp;
SELECT COUNT(*) FROM emp WHERE DEPTNO = 10;
SELECT COUNT(sal), COUNT(COMM),COUNT(NVL(comm, 0)) FROM EMP;
SELECT COUNT(sal), COUNT(COMM),COUNT(NVL(comm, 0)) FROM EMP WHERE COMM NOT null;

-- 2 . sum ()
SELECT SUM(SAL) FROM emp;
SELECT SUM(COMM) FROM emp;
SELECT SUM(ENAME) FROM EMP; --(x) 문자열은 당연히 x 숫자열만 가능
SELECT COUNT(ENAME) 총사원수
, SUM(SAL) 총급여
, round(SUM(sal)/count(ENAME),0) 평균급여
 FROM EMP;

--3 . avg()
SELECT COUNT(ENAME) 총사원수, SUM(SAL) 총급여, round(SUM(sal)/count(ENAME),0) 평균급여 FROM EMP;
union ALL
SELECT COUNT(ENAME) 총사원수, SUM(SAL) 총급여, round(avg(sal),0) 평균급여FROM EMP;

--4 . min/max
SELECT min(sal + nvl(comm,0)) 최저급여
			 ,max(sal + nvl(comm,0)) 최대급여
FROM EMP;


-- 최초입사일, 최후입사일
SELECT min(HIREDATE) 최초입사일
			 ,max(HIREDATE) 최후입사일
FROM EMP;


-- 이름
SELECT min(ENAME) 알파벳빠른사원의이름
			 ,max(ENAME) 알파벳이늦은사원이름
FROM EMP;


--- 최초입사자 최후입사자
SELECT ENAME FROM EMP WHERE HIREDATE = (SELECT min(HIREDATE) FROM EMP);
SELECT ENAME FROM EMP WHERE HIREDATE = '1987-04-19';

-- 최저급여자 최후급여자
SELECT ENAME FROM EMP WHERE SAL = 800
UNION ALL
SELECT ENAME FROM EMP WHERE SAL = 5000;



/*
	그룹화하기
	
	1 . SELECT절에 그룹함수 이외의 컬럼이나 표현식을 사용할 경우에는 반드시
			group by 절에 선언이 되어야 한다.
			
	2 . group by 절에 선언된 컬럼은 SELECT절에 선언되지 않아도 된다.
	
	3 . group by 절에는 반드시 컬럼명이나 표현식이 사용되어야 한다.
			즉 컬럼의 별칭은 사용할 수 없다.
			
	4 . GROUP BY 절에 사용한 열기준으로 정렬하기 위해서는 ORDER BY절을 사용하는
			경우에는 반드시 GROUP BY절 뒤에 선언되어야 한다.
			
	5 . ORDER BY 절에는 컬럼의 순서, 별칭으로도 선언할 수 있다.
*/
SELECT 10, SUM(SAL) FROM EMP WHERE DEPTNO = 10
UNION ALL
SELECT 20, SUM(SAL) FROM EMP WHERE DEPTNO = 20
UNION ALL
SELECT 30, SUM(SAL) FROM EMP WHERE DEPTNO = 30;



SELECT DEPTNO, SUM(SAL)
 FROM EMP
	WHERE DEPTNO = 10
	GROUP BY DEPTNO;
	
	SELECT DEPTNO 부서번호, SUM(SAL)
 FROM EMP
	GROUP BY DEPTNO
	ORDER BY DEPTNO;
	
	
		SELECT DEPTNO 부서번호, SUM(SAL)
 FROM EMP
	GROUP BY DEPTNO;
	
	
	
	SELECT DEPTNO 부서번호, SUM(SAL)
 FROM EMP
	GROUP BY DEPTNO
	ORDER BY 부서번호;


SELECT DEPTNO 부서번호, SUM(SAL)
 FROM EMP
	GROUP BY DEPTNO
	ORDER BY sum(sal) desc;
	
	
	
	
	
	-- 실습
	--ex01)
	SELECT DEPTNO,COUNT(*)사원수,ROUND(AVG(SAL),0) 평균급여,SUM(SAL) 급여합계
	 FROM EMP
	 GROUP BY DEPTNO
	 ORDER BY DEPTNO;
	 
	 --ex02)
	 SELECT JOB,COUNT(*) 인원수,ROUND(AVG(SAL),0) 평균급여,MAX(SAL) 최고급여,MIN(SAL) 최소급여,SUM(SAL) 급여합계
	 FROM EMP
	 GROUP BY JOB
	 ORDER BY JOB;



/*
	HAVING 조건절 - 그룹결과를 조건별로 조회하기
	
	단일행 함수에서의 조건은 where을 사용하지만 그룹함수에서의 조건절은
	HAVING절을 사용한다.
	
	HAVING절에는 집계함수를 가지고 조건을 비교할 경우에 사용되며
	HAVING절과 GROUP BY 절은 함께 사용할 수 있다. HAVING절은 GROUP BY절 없이 사용할 수 없다. 
*/
SELECT DEPTNO,COUNT(*)사원수,ROUND(AVG(SAL),0) 평균급여,SUM(SAL) 급여합계
	 FROM EMP
	 GROUP BY DEPTNO
	 ORDER BY DEPTNO
	 WHERE 사원수 = 4;
	 
	 -- 직급별 평균급여 , 직급별 평균급여가 3000보다 큰 직급만 조회
	 SELECT JOB 직급별
				, COUNT(DEPTNO)
				, SUM(SAL)직급별합계급여
				, ROUND(AVG(SAL),0)직급별평균급여
				, MAX(SAL)최대급여
				, MIN(SAL)최소급여
	 FROM EMP
	 GROUP BY JOB
	 HAVING ROUND(AVG(SAL),0) >= 3000;
	 
	 --실습
	 --1. 부서별 직업별 평균급여,사원수
	 --2. 부서별      평균급여,사원수
	 --3. 총계       평균급여,사원수
	select 부서, 직급, 평균, 사원수  
  from (select deptno 부서, job 직급, round(avg(sal), 0) 평균, count(*) 사원수 from emp group by deptno, job
			  union all
			  select deptno 부서, null, round(avg(sal), 0), count(*) from emp group by deptno
				union all
				select null, null, round(avg(sal), 0), count(*) from emp) t1
	order by 부서, 직급;
	 
	 
	 --rollup : 자동으로 소계와 합계를 구해주는 함수
	 -- GROUP BY rollup(deptno,job) -> n + 1의 그룹
		--순서에 주의
		SELECT DEPTNO
				--,NVL(JOB, '부서합계')
				,JOB
				,COUNT(*) 사원수
				,ROUND(avg(SAL + NVL(comm, 0))) 평균급여
				FROM EMP
				GROUP BY rollup(DEPTNO,JOB);
	 
	 
	 --실습
	 --PROFESSOR 테이블에서 DEPTNO, POSITION 별로 교수 인원수, 급여합계 구하기
	 --rollup 함수 사용
	 SELECT DEPTNO, POSITION
		,COUNT(*)교수인원수
		,SUM(PAY)급여합계
		FROM PROFESSOR
		GROUP BY rollup(DEPTNO,POSITION);
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 

