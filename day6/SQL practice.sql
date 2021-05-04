-- 포괄조인

-- 포괄조인은 실행속도를 떨어뜨린다.

-- 부서아이디, 부서명, 부서관리자아이디, 부서관리자이름 조회하기
-- 부서아이디, 부서명, 부서관리자아이디 - departments
-- 부서관리자 이름 - employees
select D.department_id, D.department_name, D.manager_id, E.first_name
from departments D, employees E
where D.manager_id = E.employee_id
order by D.department_id asc;
-- 포괄조인을 활용하면, employees테이블과 매칭되지 않는 departments의 부서정보도 조회할 수 있다.
select D.department_id, D.department_name, D.manager_id, E.first_name
from departments D, employees E
where D.manager_id = E.employee_id(+) --Employees에 manager_id가 지정되어있지 않은 사람들 까지 나타낸다. 
order by D.department_id asc;
        
--        
-- 커미션을 받는 사원들의 사원아이디, 이름, 소속부서아이디, 소속부서명 조회하기
select E.employee_id, E.first_name, D.department_id, D.department_name, D.manager_id
from employees E, departments D
where E.department_id = D.department_id(+)
and E.commission_pct is not null
order by E.employee_id;

-- 90번 부서에 소속된 사원들의 사원아이디, 이름, 해당사원의 상사이름을 조회하기
select E.employee_id, E.first_name, M.first_name
from employees E, employees M
where E.department_id = 90 
and E.manager_id = M.employee_id(+);
-- 부하직원의 manager_id가 null일때 상사쪽 employee_id가 null이어야 매칭이 되니까!!!!! 그래서 상사쪽에 +를 붙인다.


-- 오라클 조인과 ANSI조인
-- 이 두 가지의 좋고나쁨은 없고 걍 문법의 차이만있다.
-- 90번 부서에 소속된 사원들의 아이디, 이름, 직종아이디, 직종제목 조회하기
-- 오라클조인
select E.employee_id, E.first_name, J.job_id, J.title
from employees E, jobs J
where E.department_id = 90
and E.job_id = J.job_id;
-- ANSI조인
select E.employee_id, E.first_name, J.job_id, J.title
from employees E join jobs J on E.job_id = J.job_id
where E.department_id = 90;

-- 9번 부서에 소속된 사원의 아이디, 이름, 직종아이디, 직종제목, 소속부서 아이디, 소속부서명 조회하기
-- 사원의 아이디, 이름, 직종아이디, 소속부서아이디 -  employees 
-- 직종아이디, 직종제목 - jobs 
-- 소속부서아이디, 소속부서명 - departments
select E.employee_id, E.first_name, J.job_id, J.job_title, D.department_id, D.department_name
from employees E, jobs J, departments D
where E.department_id = 90
and E.job_id = J.job_id
and E.department_id = D.department_id;
-- ANSI조인
select E.employee_id, E.first_name, J.job_id, J.job_title, D.department_id, D.department_name
from employees E join jobs J on E.job_id = J.job_id
                 join departments D on E.department_id = D.department_id;

-- 90번 부서에 소속된 사원의 아이디, 이름, 급여, 급여등급을 조회하기
select E.employee_id, E.first_name, E.salary, S.grade
from employees E, salary_grade S
where E.department_id = 90
and E.salary >= S.min_salary and E.salary <= S.max_salary;
-- ANSI조인
select E.employee_id, E.first_name, E.salary, S.grade
from employees E join salary_grade S on E.salary >= S.min_salary and E.salary <= S.max_salary
where E.department_id = 90;

-- 부서아이디, 부서명, 부서담당자아이디, 부서담당자 이름 조회하기
-- 부서담당자가 결정되어 있지 않은 부서도 조회한다.
select D.department_id, D.department_name, D.manager_id, E.first_name
from departments D, employees E
where D.manager_id = E.employee_id(+);

select D.department_id, D.department_name, D.manager_id, E.first_name
from departments D join employees E on D.manager_id = E.employee_id(+);
-- left outer join : 선행테이블의 모든 행이 조회되도록 한다. (여기선 departments D가 되겠음)

select D.department_id, D.department_name, D.manager_id, E.first_name 
from employees E right outer join departments D on E.employee_id = D.manager_id;
-- right outer join : 후행테이블의 모든 행이 조회되도록 한다.


create table sample_books (
    book_no number(4),
	book_title varchar2(200),
	book_writer varchar2(100),
	book_price number(8),
	book_discount_price number(8),
	book_stock number(4),
	book_created_date date default sysdate
);

-- 테이블에 새로운 행 추가하기

-- 행의 모든 컬럼의 값을 지정해서 추가하기
insert into sample_books
(book_no, book_title, book_writer, book_price, book_discount_price, book_stock, book_created_date)
values
(101, '자바의정석', '남궁성', 35000, 29000, 1000, sysdate);

-- 행이 특정 컬럼에만 값을 지정해서 추가하기, 생략된 컬럼에는 null값이 저장된다.
insert into sample_books
(book_no, book_title, book_price)
values
(102, '이것이 자바다', 28000);

-- 행을 추가할 때 행의 모든 컬럼에 값을 추가하고, 컬럼의 순서 그대로 값을 추가할 때는
-- 컬럼명을 생략할 수 있다.
insert into sample_books
-- (book_no, book_title, book_writer, book_price, book_discount_price, book_stock, book_created_date)
values (103, '이것이 데이터분석이다.', '윤기태', 28000, 26000, 100, sysdate);

insert into sample_books
(book_no, book_title, book_writer, book_price, book_discount_price, book_stock)
values
(104, '스프링 인 액션', '미상', 30000, 27000, 20);

-- 테이블에 저장된 데이터 삭제하기
-- 테이블에 저장된 모든데이터 삭제
delete from sample_books;
-- 테이블에 저장된 데이터 중에서 특정 행을 삭제하기
delete from sample_books
where book_title like '%자바%';

delete from sample_books
where book_no = 103;

delete from sample_books
where book_no = 104;

-- 테이블에 저장된 데이터 변경하기
-- 테이블에 모든 행에 대해서 book_price컬럼의 값을 10000으로 변경하기
update sample_books
set 
    book_price = 10000;

-- 테이블의 특정 행에 대해서 book_price 컬럼의 값을 32000으로 변경하기
update sample_books
set 
    book_price = 32000
where 
    book_no = 101;
    
update sample_books
set 
    book_writer = '신용권',
    book_price = 35000,
    book_discount_price = 31500,
    book_stock = 50
where book_no = 102;

-- **정리**
-- 새로운 행의 추가
insert into 테이블명 (컬럼명,컬럼명,컬럼명,...)
values		(값,값,값,,,)

-- 테이블의 모든 행 삭제
delete from 테이블명;

--테이블에서 특정 행삭제 - 제시된 조건식이 true로 판정되는 행만 삭제한다.
delete from 테이블명
where 

--테이블에서 모든 행에 대하여 지정된 컬럼의 데이터 변경하기
update테이블명
set 
컬럼명1 = 값,
컬럼명2 = 값,
컬럼명3 = 값,
...

--테이블에서 특정 행에 대하여 지정된 컬럼의 데이터 변경하기
--제시된 조건이 true로 판정되는 행에서만 지정된 컬럼의 데이터가 변경된다
update테이블명
set 
컬럼명1 = 값,
컬럼명2 = 값,
컬럼명3 = 값,  --------*********여기 부분 정확하지 않음 물어봐야하거나 강의참조
-- *****


--sample_books 테이블에 새로운 책 정보 추가하기 (3개 이상, 책 번호는 겹치지 않도록 한다.)
insert into sample_books
(book_no, book_title, book_writer, book_price, book_discount_price, book_stock)
values 
(105, '혼자 공부하는 자바', '홍길동', 25000, 22500, 100);

-- 책번호가 104번인 책 삭제하기
delete from sample_books
where book_no = 104;

-- 책번호가 103번인 책 삭제하기
delete from sample_books 
where book_no = 104;

-- 모든 책 정보 삭제하기
delete from sample_books;

commit;