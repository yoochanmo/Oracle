/*
	단일행함수(single function)
	
	A . 문자함수
	
		1. upper / lower : 대소문자변환함수 upper('abcde') -> ABCDE, lower ('ABCDE') -> abcde
		2. initcap : 첫 글자를 대문자로 나머지는 소문자 initcap('aBcDe') -> Abcde
		3. length : 문자열의 길이를 리턴 lengrh('abcde') -> 5, length('한글')-> 2
		4. lengthb : 문자열의 byte단위 리턴(영문 1byte, 한굴은 문자셋에 따라서 2byte or 3byte를 리턴)
									lengrh('abcde') -> 5, length('한글') utf-8일 경우 6, euc-kr 4,
		5. concat : 문자열을 연결(||와 동일) concat('a','b') -> ab
		6. substr : 주어진 문자열에서 특정 위치의 문자를 추출 substr('aBcDe',2,2)-> Bc
		7. substrb : 주어진 문자열에서 특정 위치의 byte만 추출 substrb('한글',1,2) -> euc-kr 한
																								substrb('한글',1,2) -> utf-8 깨진문자
		8. instr : 주어진 문자열에서 특정문자의 위치를 리턴 instr('A*B#C#D', '#') -> 4
		9. instrb : 주어진 문자열에서 특정문자의 byte 위치를 리턴 instr('한글로','로') -> 7
		10. lpad : 주어진 문자열에서 특정문자를 앞에서 부터 채움 ipad('love',6,'*') -> **love
		11. rpad : 주어진 문자열에서 특정문자의 뒤에서 부터 채움 rpad('lobe',6,'*') -> love** ex)주민번호
		12. ltrim : 주어진 문자열에서 앞의 특정문자를 삭제 ltrim('*love','*') -> love
		13. rtrim : 주어진 문자열에서 뒤의 특정문자를 삭제 rtrim('love+','+') -> love
		14. replace : 주어진 문자열에서  A를 B로 치환 replace('AB', 'A', 'C') -> CB
*/							

	-- 1.lower/upper
	SELECT ENAME FROM EMP;
	SELECT lower(ENAME) FROM EMP;
	SELECT UPPER(LOWER(ENAME)) FROM EMP;
	
	--2. INITCAP
	
	SELECT INITCAP(ENAME) FROM emp;
	
	--3. length() / lengthb()
	
	SELECT ENAME, LENGTH(ENAME) FROM emp;
	SELECT '소향' FROM dual; --dual 은 오라클에서 제공해주는 dummy 테이블
	SELECT * FROM dual;
	SELECT '소향' dummy FROM dual;
	
	SELECT '소향', LENGTH('소향'),LENGTHB('소향') FROM dual;
	
	
	--4 . concat() or ||
	SELECT NAME, ID
		, CONCAT(name,ID)
		, CONCAT(NAME, '-')
		, concat(CONCAT(NAME, '-'),id)
		, concat(concat('홍길동의 직업은','의적입니다!'),'주소는 조선한양입니다!') as 홍길동
		, name || '-' || id as "name - id"
		, '홍길동의 직업은' || '의적입니다' || '주소는 조선한양입니다.' as "홍길동(2)"
	FROM PROFESSOR;
	
	
	
	--5 . substr(값, from, length) / substrb(값, from, length)
	-- from이 음수값이면 뒤에서 부터 처리
	
	SELECT 'abcdef'
				, substr('abcdef',3) cdef
				, substr('abcdef',3,2) cd
				, substr('abcdef',-3) def
				, substr('abcdef',-3,2) de
		FROM dual;
		
		
	SELECT '홍길동'
					,substr('홍길동',1,1) 홍
					,substrb('홍길동',1,1) 홍xx
					,substrb('홍길동',1,3) 홍
					,substrb('홍길동',1,2) 홍xx
			FROM dual;
	
	
	-- 실습, ssn 991118-1234567에서 성별구분만 추출
	SELECT '991118-1234567'
				,substr('991118-1234567',8,1) as 성별
				--1/3 남자, 2/4 여자
	FROM dual;
	
	
	
	--6. instr(문자열, 검색글자, from(기본값1), 몇번째(기본값1)
			--검색글자의 위치를 리턴해 준다.
			--시작위치가 음수이면 뒤에서부터 검색
			
	SELECT 'A*B*C*D'
			,instr('A*B*C*D','*') "2nd"
			,instr('A*B*C*D','*',3) "4th"
			,instr('A*B*C*D','*',1,2) "4th" --처음부터 시작해서 두번째의 *의 위치
			,instr('A*B*C*D','*',-5,1) "2"        --뒤에서 5번째 위치에서부터
			,instr('A*B*C*D','*',-1,2) "4th"
	FROM dual;
	
	
	SELECT 'HELLO WORLD'
			,instr('HELLO WORLD','O') "5th"
			,instr('HELLO WORLD','O',-1) "8th"
			,instr('HELLO WORLD','O',-1,1) "8th"
			,instr('HELLO WORLD','O',-1,2) "5th"
	FROM dual;
	
	
	
	--7. lpad(문자열,자리수,채울문자) / rpad(문자열,자리수,채울문자)
	SELECT NAME, ID, LENGTH(ID)
		,lpad(id,10) --채울문자 정의되지 않으면 공란으로 채워진다.
		,lpad(id,10,'*')
		,rpad(id,20,'*')
	FROM STUDENT
	WHERE DEPTNO1 = 101;
	
	
	
	
	
	--8. ltrim/rtrim
	SELECT ENAME 
		,LTRIM(ENAME, 'C')
		,RTRIM(ENAME, 'R')
	FROM EMP
	WHERE DEPTNO = 10;
	
	
	SELECT '   xxx   ' FROM dual UNION ALL
	SELECT  LTRIM('   xxx   ') FROM dual UNION ALL
	SELECT  RTRIM('   xxx   ') FROM dual; 

	
	
	
	--9. REPLACE(문자열, 변경전문자, 변경후무자)
SELECT ENAME
,REPLACE(ENAME, 'KI', '**')
,REPLACE(ENAME, 'I', '~~~~~~')
,SUBSTR(ENAME, 1, 2)
,REPLACE(ENAME,SUBSTR(ENAME, 1, 2) , '**')
--**arkm **ng, **ller substr(),replace()

FROM EMP
WHERE DEPTNO = 10;	
	
/*
 B . 숫자함수
 
		1. round : 주어진 실수를 반올림
		2. trunc : 주어진 실수를 버림
		3. mod	: 나누기 연산후 나머지값을 리턴
		4. ceil	: 주어진 실수값에서 가장 큰 정수값을 리턴
		5. floor	: 주어진 실수값에서 가장 작은 정수값을 리턴
		6. power	: 주어진 값을 주어진 승수를 리턴 power(3,3) ->3 x 3 x 3 = 27
		7. rownum : 오라클에서만 사용되는 속성으로 모든 객체에 제공된다.
				...rownum은 전체선택자 즉, *와 같이 사용할 수 없다.
				...rownum은 행번호를 의미
*/
	
	-- 1 . round(실수,반올림위치)
	SELECT 976.635
		,ROUND(976.235)
		,ROUND(976.235,0)
		,ROUND(976.235,1)
		,ROUND(976.235,2)
		,ROUND(976.235,3)
		,ROUND(976.235,-1)
		,ROUND(976.235,-2)
	FROM dual;
	
	-- 2 . trunc(실수,버림위치)
	
	SELECT 976.635
		,trunc(976.235)
		,trunc(976.235,0)
		,trunc(976.235,1)
		,trunc(976.235,2)
		,trunc(976.235,3)
		,trunc(976.235,-1)
		,trunc(976.235,-2)
	FROM dual;


-- 3 . mod, ceil, floor
SELECT 121
,MOD(121, 10)
,CEIL(121.1)
,FLOOR(121.9)
FROM dual;



-- 4 . power
SELECT '2의 3승 = ', POWER(2, 3) FROM dual UNION ALL
SELECT '3의 3승 = ', POWER(3, 3) FROM dual;


--5 . rownum
SELECT ROWNUM, NAME FROM STUDENT; --(x) rownum은 *와 같이 사용불가
SELECT ROWNUM, NAME, ID FROM STUDENT WHERE DEPTNO1 = 101;




/*
			C . 날짜함수
			
			1 . sysdate : 시스템의 현재일자 : 날짜형으로 리턴
			2 . months_between : 두 날짜 사이의 개월수를 리턴 : 숫자형
			3 . add_months : 주어진 일자에 개월수를 더한 결과를 리턴 : 날짜형
			4 . next_day : 주어진 일자를 기준으로 다음 날짜를 리턴 : 날짜형
			5 . last_day : 주어진 일자에 해당하는 월의 마지막일자를 리턴
			6 . round : 주어진 날짜를 반올림
			7 . trunc : 주어진 날짜를 버림
*/

-- 1. sysdate
SELECT SYSDATE FROM dual;

-- 2. MONTHS_BETWEEN
SELECT MONTHS_BETWEEN(SYSDATE, '20190101') FROM dual; --ms 기준 

--근속월수는 ?
SELECT MONTHS_BETWEEN(SYSDATE,HIREDATE) FROM emp;


-- 3. ADD_MONTHS
SELECT SYSDATE
	,ADD_MONTHS(SYSDATE, -312)
FROM dual;

-- 4 . next_day
-- 현재일에서 다음의 요일 
SELECT SYSDATE
	,NEXT_DAY(SYSDATE, 1) -- 1 ~ 7 : 일요일(기준) ~ 토요일
	,NEXT_DAY(SYSDATE, 2)
	,NEXT_DAY(SYSDATE, 3)
	,NEXT_DAY(SYSDATE, 4)
	,NEXT_DAY(SYSDATE, 5)
	,NEXT_DAY(SYSDATE, 6)
	,NEXT_DAY(SYSDATE, 7)
FROM dual;

-- 5 . LAST_DAY
SELECT SYSDATE
		,LAST_DAY(SYSDATE)
		,LAST_DAY('20230301')
		,LAST_DAY('2023-03-01')
		,LAST_DAY('2023.03.01')
		,LAST_DAY('2023/03/01')
		--,LAST_DAY('2023-MAR-01')(x)
		--,LAST_DAY('03/01/2023')(x)
		--,LAST_DAY('OCT012023')(x)
FROM dual;



-- 6 . round / trunc
SELECT SYSDATE
	,ROUND(SYSDATE)
	,TRUNC(SYSDATE)
	,ROUND('20230301')
	,trunc('20230331')
FROM dual;


/*  D. 형변환 함수
	
		1 . to_char() : 날짜 or 숫자를 문자로 변환 함수
		2 . to_number() : 문자형숫자를 숫자로 변환(단, 숫자형식에 맞아야 함)
		2 . to_date()		: 문자형을 날짜로 변환(단, 날짜형식에 맞아야 함)
		
*/


-- 1 . 자동형변환 / 수동형변환

--1) 자동(묵시적)형변환
SELECT '2' + 2 FROM dual --'22'가 아니라 '2' 숫자로 변화되고 연산
UNION ALL
SELECT 2 + '2' FROM dual; -- 즉 ,문자와 숫자의 연산의 우선순위는 숫자에 있다.


--2) 수동(명시적)형변환
SELECT TO_NUMBER('2') + 2 FROM dual
UNION ALL
SELECT 2 + TO_NUMBER('2') FROM dual;

SELECT '2a' + 2 FROM dual; --(x)
SELECT 'A' + 2 FROM dual; --(x)

-- 2. to_char()
--1) 날짜를 문자로 변환
SELECT SYSDATE
,TO_CHAR(SYSDATE)
,TO_CHAR(SYSDATE, 'YYYY') 년도
,TO_CHAR(SYSDATE, 'RRRR') 년도
,TO_CHAR(SYSDATE, 'YY')
,TO_CHAR(SYSDATE, 'RR')
,TO_CHAR(SYSDATE, 'yy')
,TO_CHAR(SYSDATE, 'YEAR')
,TO_CHAR(SYSDATE, 'year')
FROM dual; 


SELECT SYSDATE
,TO_CHAR(SYSDATE)
,TO_CHAR(SYSDATE, 'MM')월
,TO_CHAR(SYSDATE, 'MON')월
,TO_CHAR(SYSDATE, 'MONTH')
,TO_CHAR(SYSDATE, 'mon') --DEC dec
FROM dual;


SELECT SYSDATE
,TO_CHAR(SYSDATE)
,TO_CHAR(SYSDATE, 'DD')일
,TO_CHAR(SYSDATE, 'DAY')일
,TO_CHAR(SYSDATE, 'DDTH')일
,TO_CHAR(SYSDATE, 'dd')일
,TO_CHAR(SYSDATE, 'day')일
,TO_CHAR(SYSDATE, 'ddth')일
FROM dual;

SELECT SYSDATE
,TO_CHAR(SYSDATE)
,TO_CHAR(SYSDATE, 'YYYY.MM.DD')
,TO_CHAR(SYSDATE, 'yyyy.mm.dd')
,TO_CHAR(SYSDATE, 'YYYY.MM.DD.hh24:mi:ss') --연월일시분초 hh24 24시간단위
,TO_CHAR(SYSDATE, 'MON.DD.YY.hh24:mi:ss')
FROM dual;



SELECT WHERE 입사일 = to_char(SYSDATE, 'YYYY.MM.DD HH:MI:SS');




--2) 숫자를 문자로 변환
-- 12345 -> 12,345 or 12345.00 형태로 변환
SELECT 1234
		,TO_CHAR(1234,'9999')
		,TO_CHAR(1234,'99999999999')
		,TO_CHAR(1234,'09999999999')
		,TO_CHAR(1234,'$9999')
		,TO_CHAR(1234,'$9999.99')
		,TO_CHAR(1234,'9,999')
		,TO_CHAR(123456789,'9,999')
		,TO_CHAR(123456789,'999,999,999')
		
FROM dual;


/*
	E . 기타함수
	
	1. nvl() : null 값을 다른 값으로 치환하는 함수 nvl(comm,0)
	2. nvl2() : null	값을 다른 값으로 치환하는 함수 nv2(comm,true,false)
	3. decode() : 오라클에서만 사용하는 함수 if~else
	4. case			: decode 대신에 일반적으로 사용되는 문장
	
			case 조건 when 결과1 then 출력1,
							 [when 결과n then 출력n]
			end as 별칭

*/

SELECT SAL, nvl(comm,0), SAL + nvl(COMM,0) FROM emp;


-- 1. nvl()
SELECT NAME,PAY,BONUS
		, PAY + BONUS as total
		, NVL(BONUS,0)
		, TO_CHAR(PAY+ NVL(BONUS,0), '999,999') 총급여
	FROM PROFESSOR
	WHERE DEPTNO = 201;


-- 2. nvl2(col, null아니면, null 이면)

SELECT NAME,PAY,BONUS
	,nvl2(BONUS,BONUS,0) 보너스
	,nvl2(BONUS, PAY+BONUS,PAY) as 총급여
FROM PROFESSOR
WHERE DEPTNO = 201;


SELECT ENAME, SAL, COMM
		,SAL + NVL(comm,0)
		,SAL + NVL(comm,100)
		,NVL2(comm, 'null값이 아닙니다!','null값입니다')
		,NVL2(comm,'comm이 있습니다', ENAME || '은 comm이 없습니다.')
FROM EMP;


-- 1)
SELECT NAME,PAY,BONUS,DEPTNO
	,TO_CHAR((PAY*12) + NVL(BONUS, 0)) as 연봉
	FROM PROFESSOR
WHERE DEPTNO = 201;

--2)
SELECT DEPTNO,COMM,ENAME
	,NVL2(comm,'Exist', 'NULL')
FROM EMP
WHERE DEPTNO = 30;




--3. decode 함수
--1) 통상적으로 if~else문을 decode로 표현한 함수로 오라클에서만 사용되는 함수
--2) 오라클에서 자주 사용하는 중요한 함수이다.!!
--3) decode(col, true,false) 즉, col의 결과(값)이 true일 경우 true실행문을 실행, 아니면 false실행문을 실행
--4) decode(deptno, 101, true,
--									102, true,
--									103, true, false) -> if ~ else if~else
--5) decode(deptno, 101, decode()...) 중첩 if문

-- 101이면 컴퓨터공학, 아니면 기타학과
SELECT NAME, DEPTNO
	,DECODE(DEPTNO, 101,'컴퓨터공학') --if(true) {} 인 상태
	,DECODE(DEPTNO, 101,'컴퓨터공학','기타학과') -- if(true) {} else {}
	FROM PROFESSOR;


SELECT * FROM DEPARTMENT;

-- 101 컴공, 102 미디어융합, 103 소프트공학,나머지는 기타학과
SELECT NAME, DEPTNO
	,DECODE(DEPTNO, 101,'컴퓨터공학'
								, 102,'미디어융합'
								, 103, '소프트공학'
								, '기타학과') -- if(true) {} else if {} else if {}
	FROM PROFESSOR;



-- 중첩decode
-- 101학과 교수중에서 Audie Mirphy교수는 'Best PROFESSOR' 아니면 'Good', 101이외 학과교수는 N/A

SELECT NAME,DEPTNO
	,DECODE(NAME, 'Audie Murphy', 'Best Professor'
							 ,'Good')
	,DECODE(DEPTNO,101, '학과'
							,	'N/A'	)
FROM PROFESSOR;


-- 실습
--1)STUDENT 전공이 101인 학생들중에 jumin 성별 구분해서
-- 1 or 3 = 남자 , 2 or 4 = 여자를 출력
-- name, jumin,gender

SELECT NAME, JUMIN,DEPTNO1,
       DECODE(SUBSTR(JUMIN,7,1),'1','남자',
                                 '2','여자',
                                 '3','남자',
                                 '4','여자') AS 성별
FROM STUDENT
WHERE DEPTNO1 = 101;








--2) student 테이블에서 1 전공이 (deptno1) 101번인 학생의 이름과
--		연락처와 지역을 출력하세요. 단 지역번호가 02 서울 031 경기도 051 부산 052 울산 055 경남
--		substr,instr,decode

SELECT NAME,TEL,DEPTNO1
	,SUBSTR(tel, 1, 3)
	,INSTR(tel, ')',1,1)
	,SUBSTR(tel, 1, instr(tel, ')',1,1)-1)
	,DECODE(SUBSTR(TEL, 1, instr(tel,')',1,1)-1),
												'031','경기도',
												'02', '서울',
												'051', '부산',
												'052', '울산',
												'055', '경남') AS 지역
	FROM STUDENT
WHERE DEPTNO1 = 101;

												
-- 4 . case문
	--1) case 조건 when 결과 then 출력
	select name, tel 
     , substr(tel, 1, 3)
		 , instr(tel, ')', 1, 1)
		 , substr(tel, 1, instr(tel, ')', 1, 1)-1)
		 , decode(substr(tel, 1, instr(tel, ')', 1, 1)-1), 
				'02',  '서울',
				'031', '경기',
				'051', '부산',
				'052', '울산',
				'055', '경남',
				'기타') as 지역
		 , case substr(tel, 1, instr(tel, ')', 1, 1)-1) 
				    when '02'  then '서울'
				    when '031' then '경기'
				    when '051' then '부산'
				    when '052' then '울산'
				    when '055' then '경남'
				    else '기타'
				end as 지역
  from student;
	
	
	
	
	
	--2) case when betwwen 값1 and 값2 then 출력...
	-- emp 테이블에서 sal 1~1000 1등급, 1001~2000 2등급,... 4001보다 크면 5등급
	SELECT ENAME
				,SAL
				,case when SAL BETWEEN 1 and 1000 then '1등급'
							WHEN SAL BETWEEN 1001 AND 2000 then '2등급'
							WHEN SAL BETWEEN 2001 AND 3000 then '3등급'
							WHEN SAL BETWEEN 3001 AND 4000 then '4등급'
							WHEN SAL > 4000 THEN '5등급'
							end as 등급
							FROM EMP;
	
	
	
