-- 제약조건 정의하기
-- 컬럼레벨 제약조건 정의방식 사용 (컬럼을 정의할 때 같이 제약조건까지 정의)
create table sample_todos (
   todo_no number(8) 
      constraint sampletodos_no_pk primary key, -- 별칭정하기> 테이블이름_이름_pk 보통이렇게 정한다., 30자가 넘어서는 안된다.
   todo_title varchar2(250) 
      not null,
   todo_writer varchar2(20) 
      constraint sampletodos_writer_fk references sample_users (user_id), -- forign key라서 user_id만 들어갈 수 있다.
   todo_day date not null,
   todo_status varchar2(10) default '등록'
      constraint sampletodos_status_ck check (todo_status in ('등록', '삭제', '완료')),
   todo_text varchar2(1000) 
      constraint sampletodos_text_nn not null,
   todo_created_date date default sysdate,
   todo_completed_date date,
   todo_deleted_date date
);
-- 생성된 테이블 삭제하기
drop table sample_todos;

-- 테이블 레벨 제약조건 정의방식 사용 (테이블 적고 제약조건을 따로 적음)
create table sample_todos (
    todo_no number(8), 
    todo_title varchar2(250)               not null,
    todo_writer varchar2(20)               not null,
    todo_day date                          not null,  
    todo_status varchar2(10) default '등록',
    todo_text varchar2(1000)               not null,
    todo_created_date   date default sysdate,
    todo_completed_date date,
    todo_deleted_date   date,
    
    constraint sampletodos_no_pk        primary key (todo_no),
    constraint sampletodos_writer_fk    foreign key (todo_writer) references sample_users (user_id),
    constraint sampletodos_status_ck    check (todo_status in ('등록', '완료', '삭제')),
    constraint sampletodos_text_nn not null
);

-- 상품을 여러 종류 담을 수 있는 장바구니 테이블 정의하기
-- 이거보면 컬럼레벨제약조건이랑 테이블레벨제약조건이랑 같이 써도됨
create table sample_cart_items (
    item_no number(8)               constraint cartitems_no_pk primary key,
    user_id varchar(20)             not null,
    product_no number(8)            not null,
    item_amount number(4)           default 1,
    item_created_date               date default sysdate,
    
    constraint cartitems_userid_fk foreign key(user_id) references sample_users (user_id),
    constraint cartitems_productno_fk foreign key(product_no) references sample_products (product_no),
    constraint cartitems_uk unique (user_id, product_no)
);

-- 시퀀스만들기 일련번호를 생성해준다.
create sequence cartitem_seq nocache;
create sequence todo_seq nocache;

-- sample_cart_items 테이블에 장바구니 상품정보 추가하기 / 2번 실행하면 고유키 제약조건 위배 에러가뜸
insert into sample_cart_items
(item_no, user_id, product_no, item_amount, item_created_date)
values 
(cartitem_seq.nextval, 'hong', 60, 1, sysdate);

insert into sample_users
(user_id, user_name, user_password)
values
('hong', 'gildong', 'zxcv1234');

-- sample_products 테이블에서 64번 상품 삭제하기 -> 오류 참조하고 있는 child record가 있어서 삭제가 안된다.
-- 자식레코드가 존재하면 부모레코드를 삭제할 수 없다.
delete from sample_products
where product_no = 64;

-- 오류발생 ORA-02292

-- 여기 적어야됨 
-- sample_products 테이블의 64번 상품을 참조하는 행이 sample_items테이블에
-- 존재하고 있기 때문에 64번 상품은  삭제할 수 없다.

-- sample_cart_items의 상품수량 번경하기
update sample_cart_items
set
    item_amount = 0
where item_no = 6;
-- ORA-02290: check constraint (HR.CARTITEMS_AMOUNT_CK) violated
-- 오류 : item_amount에 정의되어있는 체크제약조건 위배

-- 인텍스 생성하기
-- sample_users 테이블의 user_phone컬럼의 값으로 사용자를 조회하는 일이 빈번하게 있다.
-- 전화번호로 사용자를 빠르게 검색할 수 있도록 user_phone컬럼의 값으로 인텍스(색인)을 생성하기
-- sample_user_phone_idex의 내용

-- user_phone    rowid
--------------------------------------
-- 010-0001-0001 AAAAAA AAE AAAACT AAA
-- 010-0001-0002 AAAAAA AAE AAAACT AAE
-- 010-0001-0011 AAAAAA AAE AAAACT ABA
-- 010-0001-0291 AAAAAA AAE AAAACT AAZ
-- 010-0001-1234 AAAAAA AAE AAAACT AZZ
-- 010-0001-1256 AAAAAA AAE AAAACT AZA

-- 이렇게 색인이 있으면 색인으로 찾는다. 
create index sample_user_phone_idx
on sample_users(user_phone);

-- sample_users 테이블에서 user_phone컬럼의 값이 where절의 조회조건으로 사용되면
-- 자동으로 sample_user_phone_idx 인덱스 (색인) 에서 해당전화번호의 ROWID를 사용해서
-- 사용자정보(데이터행)를 빠르게 검색한다.

select *
from sample_users
where user_phone = '010-1111-2222';

-- 이 아래처럼 적으면 오류 근데 위처럼 적으며 안오류
-- 이 색인이 없으면 테이블을 처음부텉 끝까지 찾고 
select *
from sample_users
where user_phone = '010-1111-2222';
-- 색이이있냐 없냐에 따라 쿼리실행은 같아도 찾는 방식이 다름 색인이 옴춍중요하다.

-- Top-N분석과 분석함수 사용하기

-- Top_N분석하기 : rownum을 사용한다.
-- 월급에 대한 내림차순으로 정렬했을 때,
-- 급여를 가장 많이 받은 사람 3명의 아이디, 이름, 급여, 조회하기
select rownum, employee_id, first_name, salary
from (select employee_id, first_name, salary
      from employees
      order by salary desc)
where rownum <= 3;

-- 분석함수
-- rank(), dense_rank(), row_umumber()
-- select 분석함수() over ([partition by 컬럼] [order by 컬럼]), 컬럼, 컬럼
-- from 테이블명

--rank(), dense_rank(), row_number()으로 랭킹, 순번 부여하기 -- 이거 실행해바
select rank() over(order by salary desc), ranking,
       dense_rank() over(order by salary desc), dense-ranking, --dense_rank랑 now number랑 차이보기
       row_number() over (order by salary desc) row_number,    -- row_num을 더 많이씀
        employee_id, first_name, salary
from employees;

-- 각 부서에서 급여를 가장 많이 받는 사람 조회하기
select rank() over (partition by department_id order by salary desc) ranking,
     employee_id, first_name, department_id, salary
from employees
order by department_id, salary desc;
-- 위를 아래로 고쳐쓸 수 있다.
select department_id, employee_id, first_name, salary
from (select rank() over (partition by department_id order by salary desc) ranking,
     employee_id, first_name, department_id, salary
from employees
order by department_id, salary desc)
where ranking = 1
and department_id is not null;

-- 입사년도별 급여를 가장 많이 받는 사람 조회하기
select 
    hire_year, 
    employee_id, 
    first_name, 
    salary
from (select rank() over (partition by to_char(hire_date, 'yyyy') order by salary desc),
            to_char(hire_date, 'yyyy') hire_year,
            employee_id, 
            first_name, 
            salary
      from employees)
where ranking = 1;
-- select를 from안으로 넣어보는거 적응안될줄 알았는데 하다보니까 적응되네 

-- row_number() 분석함수를 사용해서 순번을 부여하고, 특정 범위의 데이터를 조회하기
select 
    row_number,
    employee_id,
    first_name
from (select 
        row_number() over (order by employee_id) row_number, employee_id, first_name
    from employees)
where row_number >= (? - 1)*10+1 and row_number <= ?*10;