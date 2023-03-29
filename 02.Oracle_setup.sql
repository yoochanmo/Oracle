-- 한줄 주석
/* 블럭 주석 */

-- 1 . Oracle 사용자 조회
-- show user : SQL*Plus 명령으로 오라클에서만 사용가능한 명령
select * FROM DBA_USERS;
SELECT PASSWORD, username, USER_ID, LOCK_DATE from dba_users;

-- 2 . 사용자 권한(role) 조회
-- 명령들은 대소문자 구분을 하지 않는다.
-- 문자열은 반드시 작은 따옴표만 가능, 큰 따옴표는 열이름등을 정의할 때 사용
-- 문자열은 대소문자 구분을 한다.
-- SYS CONNECT 는 접속 권한
-- SYS 리소스는 편집 권한
SELECT * from DBA_ROLE_PRIVS;
SELECT * FROM DBA_ROLE_PRIVS where GRANTEE = 'SYS';
SELECT * FROM DBA_ROLE_PRIVS where GRANTEE = 'HR';

-- 3 . 사용자 권한 조회
select * from DBA_SYS_PRIVS;
select * from DBA_SYS_PRIVS where GRANTEE = 'SYS';
select * from DBA_SYS_PRIVS where GRANTEE = 'DBA';
select * from DBA_SYS_PRIVS where grantee = 'HR';
select * from DBA_SYS_PRIVS where grantee = 'SCOTT';

-- 4 . lock 된 사용자 unlock 하기
SELECT * FROM dba_users where USERNAME = 'HR';
SELECT USERNAME, ACCOUNT_STATUS, LOCK_DATE FROM dba_users where USERNAME = 'HR';
-- 사용자잠금해제명령

-- unlock 잠금해제 명령
ALTER USER hr account unlock; 

--lock 잠금 명령
ALTER USER hr account LOCK;		

-- 사용자 비밀번호 변경(설정)하기

ALTER USER HR IDENTIFIED BY HR;
SELECT USERNAME, ACCOUNT_STATUS, LOCK_DATE, PASSWORD
	FROM DBA_USERS
	WHERE USERNAME = 'HR';
	
--사용자가 가지고 있는 테이블 목록 조회하기
SELECT * FROM tabs;

/* 사용자 생성하기
실습. 사용자 확인, HR과 SCOTT 각각 확인해 보기
키워드는 대소문자를 구분하지만 값(문자열,'')은 대소문자 구분을 한다.
*/
select * from DBA_USERS WHERE USERNAME = 'HR';
SELECT * FROM DBA_USERS where USERNAME = 'SCOTT';

SELECT USERNAME, ACCOUNT_STATUS, LOCK_DATE
FROM DBA_USERS 
where USERNAME = 'SYS'
		or USERNAME = 'HR'
		or USERNAME = 'SCOTT';
		
-- 1 . 사용자계정생성하기
-- 계정과 비밀번호를 동시에 적용하는 명령
CREATE USER scott IDENTIFIED by tiger;

SELECT USERNAME, ACCOUNT_STATUS, LOCK_DATE
FROM DBA_USERS 
where USERNAME = 'SYS'
		or USERNAME = 'HR'
		or USERNAME = 'SCOTT';
		
--권한 확인하기

SELECT * 
FROM dba_role_privs
WHERE grantee = 'HR'
		or grantee = 'SCOTT';

--권한
SELECT * FROM dba_sys_privs
 where grantee ='HR'
 or grantee = 'SCOTT';



--role 부여하기
--role or 권한을 부여하는 명령 grant
GRANT CONNECT to scott;
GRANT RESOURCE to scott;
GRANT CONNECT, RESOURCE to scott;

--scott이 사용할 작업장소 부여하기
ALTER USER scott DEFAULT tablespace users;
ALTER USER scott temporary tablespace temp;


-- 3 . navicat에 scott등록하기


-- 4 . 실습용 데이터 (테이블) 생성하기
--dept, emp, bonus, salgrade 테이블 생성

CREATE TABLE DEPT
   (DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
    DNAME VARCHAR2(14) ,
    LOC VARCHAR2(13) ) ;

CREATE TABLE EMP  
   (EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,  
    ENAME VARCHAR2(10),  
    JOB VARCHAR2(9),  
    MGR NUMBER(4),  
    HIREDATE DATE,  
    SAL NUMBER(7,2),  
    COMM NUMBER(7,2),  
    DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT);

INSERT INTO DEPT VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');   
INSERT INTO DEPT VALUES (30,'SALES','CHICAGO');  
INSERT INTO DEPT VALUES (40,'OPERATIONS','BOSTON');

INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-7-1987','dd-mm-yyyy')-85,3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-7-1987','dd-mm-yyyy')-51,1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);

CREATE TABLE BONUS
    (
    ENAME VARCHAR2(10)  ,
    JOB VARCHAR2(9)  ,
    SAL NUMBER,
    COMM NUMBER
    ) ;
      
CREATE TABLE SALGRADE
      ( GRADE NUMBER,
    LOSAL NUMBER,
    HISAL NUMBER );
   
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);
























