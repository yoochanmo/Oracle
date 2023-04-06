/*
	Sequence
	
	시퀀스란 ? 순차적으로(자동)  증감하는 일련번호를 생성하는 오라클 데이터베이스의 객체이다.
	보통 PK값에 중복을 방지하기 위해서 종종 사용한다. 예를 들어 게시판에 글이 하나가 추가될 때
	마다 글번호(PK)가 생겨야 한다면 시퀀스를 사용하면 보다 쉽게,편리하게 PK를 관리할 수가 있다.
	
	
	1 . 유일한 값을 생성해 주는 오라클객체중 하나.
	2 . 시퀀스를 생성하면 기본키와 같이 순차적으로 증가하는 컬럼을 자동으로 생성이 가능하다.
	3 . 보통 PK값을 생성하기 위해 사용한다.
	4 . 시퀀스는 테이블과 독립적으로 저장되고 생성된다.
	
	[sequence 문법]
	
	1 . create sequence 시퀀스명
			[start with n] -- 이것을 생략하면 기본값 1 씩 증가
			[increment by n] -- 이것을 생략하면 기본값은 1이다.
			[maxvalue n | nomaxvalue] --이것을 생략하면 기본값은 nomaxvalue(999999999999)
			[minvalue n | nominvalue] --이것을 생략하면 기본값은 nominvalue
			[cycle | nocycle]		-- 이것을 생략하면 nocycle
			[cache | nocache]   -- 이것을 생략하면 nocache
			
			
			...start with : 시퀀스의 시작함을 정의 n을 1000이라 지정하면 1000부터 시작 정의하지 않으면 1부터 시작
			..increment by : 자동증가값을 정의, n 10이면 10씩 증가
			..maxvalue  : 시퀀스의 최대값, 기본값 nomaxvalue
			..minvalue	: 시퀀스의 최소값, 기본값 nominvalue
			..cycle :  최대값에 도달한 경우에 처음부터(start with) 다시 시작할지 여부를 정의
			..cache : 원하는 숫자만큼 미리 생성해서 메모리에 저장했다 하나씩 꺼내서 사용여부
			
			
		2 . 시퀀스변경
			
				alter sequence 시퀀스명
				[increment by n]
				[maxvalue n | nomaxvalue] 
				[minvalue n | nominvalue] 
				[cycle | nocycle]		
				[cache | nocache]  
				
				
				
		3 . 시퀀스삭제
		
				drop sequence 시퀀스명
				
				
		4 . 시퀀스조회
			
				SELECT * FROM user_sequences
				SELECT * FROM all_sequences
			
				
			
*/


				SELECT * FROM user_sequences;
				SELECT * FROM all_sequences;
				
				
	-- 1 . 시퀀스 생성하기
	CREATE sequence jno_seq
			start with 100
			INCREMENT BY 1
			maxvalue 110
			minvalue 90
			cycle
			cache 2;
					
				
SELECT * FROM user_sequences;
				
				
	-- 2 . 시퀀스 실습
	CREATE TABLE s_order(
			ord_no number(4)
		,ord_name VARCHAR2(10)
		,p_name VARCHAR2(20)
		,p_qty number
	);
	
	SELECT * FROM s_order;
	
	
	-- 시퀀스 접근 명령
	-- 현재번호 : 시퀀스명.currval
	-- 다음번호 : 시퀀스명.nextval
	
	SELECT jno_seq.currval FROM dual;
	 --ORA-08002: sequence JNO_SEQ.CURRVAL is not yet defined in this session  < 사용한적이 한번도 없기 때문에 currval 워닝에러
				
		insert into s_order values(jno_seq.nextval,'홍길동','홍삼',10);		
				
					SELECT jno_seq.currval FROM dual;
					SELECT * FROM s_order ;
				
				
				insert into s_order values(jno_seq.nextval,'손흥민','스마트폰',1);		
					SELECT jno_seq.currval FROM dual;
					SELECT * FROM s_order ;
				
				SELECT * FROM user_sequences;
				
				
		-- minvalue, maxvalue 테스트
		begin
			for i in 1..9 loop
			insert into s_order values (jno_seq.nextval,'소향','노트북',1);
			end loop;
		end;		
				
				
				
				
				
		-- cycle 테스트
		insert into s_order values(jno_seq.nextval,'이강인','축구공',1);		
					SELECT jno_seq.currval FROM dual;
					SELECT * FROM s_order ;
				
				SELECT * FROM user_sequences;		
				
				
				
	
				SELECT jno_seq.currval FROM dual;
				SELECT * FROM s_order ;
				SELECT * FROM user_sequences;
				
				
				
	--	별도의 시퀀스를 적용하기
	CREATE sequence jno_seq_01;		
	insert into s_order values(jno_seq_01.nextval,'거미','mp3',1);		
					SELECT jno_seq.currval FROM dual;
					SELECT * FROM s_order ;			
				SELECT * FROM user_sequences;
				
				
		-- 감소하는 sequence
		CREATE sequence jno_seq_rev
		increment by -2
		minvalue 0
		maxvalue 20		
		start with 20;
				
				
				
	SELECT * FROM user_sequences;
				
				
				
		CREATE TABLE s_rev_01(no number);
		SELECT * FROM s_rev_01;		
				
				
		INSERT into s_rev_01 values (jno_seq_rev.nextval);
				
				SELECT * FROM s_rev_01;	
				SELECT * FROM user_sequences;
				
				
		-- 시퀀스 삭제하기
		
		drop sequence jno_seq_01;
				
		SELECT * FROM jno_seq_01;
				
		-- 보통의 경우 sequence를 PK로 사용
		CREATE sequence test_seq;
		CREATE TABLE test_table(no number primary key);		
				
				
		insert into test_table values(test_seq.nextval);		
		insert into test_table values(test_seq.nextval);		
		insert into test_table values(test_seq.nextval);		
		insert into test_table values(test_seq.nextval);		
		insert into test_table values(test_seq.nextval);		
				
				SELECT * FROM test_table;
				
				
		insert into test_table values(6);	
		
		
--중복에러
			insert into test_table values(test_seq.nextval);	--ORA-00001: unique constraint (SCOTT.SYS_C007098) violated 중복에러
			SELECT * FROM test_table;
				
		
		SELECT test_seq.nextval FROM dual;	
		SELECT test_seq.nextval FROM dual;	
		SELECT test_seq.nextval FROM dual;		
		SELECT test_seq.nextval FROM dual;			
				
				