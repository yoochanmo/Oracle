select * from dba_users;
select * from all_users;
alter user hr account lock;
alter user hr account unlock;
select * from tab;

/*
	Oracle 기본 date 형식 변경하기
*/

-- 	1. 오라클 환경변수 조회하기
select * from v$nls_parameters;

--  2. 날짜형식 변경하기
-- alter session[system] set 시스템변수 = 변경할 값
alter session set NLS_DATE_FORMAT = 'YYYY.MM.DD'; --dateformat 변경
alter session set NLS_timestamp_FORMAT = 'YYYY.MM.DD HH:MI:SS'; --timestamp format 변경
select * from hr.employees;

-- 영구적(system 레벨)

alter system set NLS_DATE_FORMAT = 'YYYY.MM.DD' scope=spfile; 
alter SYSTEM set NLS_timestamp_FORMAT = 'YYYY.MM.DD HH:MI:SS' scope=spfile; 
--scop
-- 1. both : 바로적용 or 재시작 (에러확률이 있음)
-- 2. spfile : 재시작
-- SQL command line에서 system사용자로 변경후 DB 재시작 
