/*
	Join 문법
	
	1. Oracle문법
	
		select t1.ename, t2.dname
		  from emp t1, dept t2
		 where t1.deptno = t2.deptno
	
	2. Ansi Join
	
	   select t1.ename, t2.dname
		   from emp t1 [inner|outer|full]join dept t2 on t1.deptno = t2.deptno
*/

select deptno, ename from emp;
select deptno, dname from dept;

-- oralce join
select ename, dname, emp.deptno
  from emp, dept
 where emp.deptno = dept.deptno;
 
-- ansi join
select ename, dname
	from emp join dept on emp.deptno = dept.deptno;

select ename, dname
	from emp inner join dept on emp.deptno = dept.deptno;
	
-- table의 별칭
select e.ename, dpt.dname, e.deptno
  from emp e, dept dpt
 where e.deptno = dpt.deptno;

/*
	join의 종류
	
	1. equi-join(등가조인), inner join
	2. outer join 
	3. full join
*/

-- A. equi-join
-- 실습1. student, professor에서 지도교수의 이름과 학생이름을 출력
-- oracle과 ansi join 각각 조회하기
-- 학생명과 교수명만 출력해 보기
select * from professor;
select * from student;
select * from department;

select pro.name, std.name
  from professor pro, student std
 where pro.deptno = std.deptno1;

select pro.name 교수명, std.name 학생명
  from professor pro, student std
 where pro.profno = std.profno;

select pro.name 교수명, std.name 학생명
  from professor pro inner join student std
    on pro.profno = std.profno;
		
select count(*) from student;

select pro.name 교수명, std.name 학생명
  from professor pro inner join student std
    on std.profno = pro.profno;

-- 실습2. student, professor, deaprtment에서 교수명, 학생명, 학과명을 출력
-- 표준문법(where, and) , ansi(inner 2번) 각각
select std.name 학생명, pro.name 교수명, dpt.dname 학과명
  from student std, professor pro, department dpt
 where std.profno = pro.profno
   and pro.deptno = dpt.deptno;

select std.name 학생명, pro.name 교수명, dpt.dname 학과명
  from student std inner join professor  pro on std.profno = pro.profno
									 inner join department dpt on pro.deptno = dpt.deptno;

select std.name 학생명, pro.name 교수명, dpt.dname 학과명
  from student std inner join professor  pro on std.profno = pro.profno
									 inner join department dpt on std.deptno1 = dpt.deptno;

-- B. outter-join
select count(*) from student;
select count(*) from student where profno is null;

-- 지도교수가 정해져 있지 않은 학생까지도 출력
-- 1) oralce에서만 사용되는 문법

-- 지도교수가 할당이 되지 않은 학생
select std.name 학생명, pro.name 교수명
  from student std, professor pro
 where std.profno = pro.profno(+);

-- 학생이 할당되지 않은 지도교수까지
select std.name 학생명, pro.name 교수명
  from student std, professor pro
 where std.profno(+) = pro.profno;

-- 2) ansi outer join
select std.name 학생명, pro.name 교수명
  from student std inner join professor pro on std.profno = pro.profno;

select std.name 학생명, pro.name 교수명
  from student std left outer join professor pro on std.profno = pro.profno;

select std.name 학생명, pro.name 교수명
  from student std right outer join professor pro on std.profno = pro.profno;

-- C. self join
select empno from emp;
select mgr from emp;

select emp.empno, emp.ename  -- 사원
     , mgr.empno, mgr.ename  -- 해당 사원의 매니저
  from emp emp, emp mgr
 where emp.mgr = mgr.empno;


/* 연습문제 */
-- ex01) student, department에서 학생이름, 학과번호, 1전공학과명출력


-- ex02) emp2, p_grade에서 현재 직급의 사원명, 직급, 현재 년봉, 해당직급의 하한
--       상한금액 출력 (천단위 ,로 구분)

	 
-- ex03) emp2, p_grade에서 사원명, 나이, 직급, 예상직급(나이로 계산후 해당 나이의
--       직급), 나이는 오늘날자기준 trunc로 소수점이하 절삭 


-- ex04) customer, gift 고객포인트보나 낮은 포인트의 상품중에 Notebook을 선택할
--       수 있는 고객명, 포인트, 상품명을 출력	 


-- ex05) professor에서 교수번호, 교수명, 입사일, 자신보다 빠른 사람의 인원수
--       단, 입사일이 빠른 사람수를 오름차순으로

 
-- ex06) emp에서 사원번호, 사원명, 입사일 자신보다 먼저 입사한 인원수를 출력
--       단, 입사일이 빠른 사람수를 오름차순 정렬




















