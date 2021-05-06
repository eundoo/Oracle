-- 다중행 함수(그룹함수)
-- employees 테이블에 저장된 모든 사원들의 수를 조회하기
select count(*)
from employees;

-- 60번 부서에 소속된 사원들의 수를 조회하기
select count(*)
from employees
where department_id = 60;

-- 커미션을 받는 사원들의 수를 조회하기
select count(*)
from employees
where commission_pct is not null;

select count(commission_pct)
from employees;

-- group by 를 이용해서 테이블의 행들을 그룹화하기
-- 같은 부서에 소속된 사원들끼리 그룹화한 다음 그룹함수를 적용해보기
select department_id, count(*)
from employees
group by department_id;

-- 부서별로 사원들을 그룹화한 다음, 부서별 급여총합, 급여평균을 조회하기
select department_id, sum(salary), round(avg(salary))
from employees
group by department_id;

-- 부서별로 사원들을 그룹화한 다음 부서별 급여총합, 급여평균을 조회하기
-- 부서이름, 부서별 급여총합, 부서별 급여평균을 조회하기
select D.department_name, sum(salary), round(avg(salary))
from employees E, departments D
where E.department_id = D.department_id
group by D.department_name;

-- 부서별로 사원들을 그룹화하고, 같은 부서에 소속된 사원들을 직종으로 다시 그룹화 한다음
-- 해당 그룹에 속하는 사원들의 숫자를 조회하기
select department_id, job_id, count(*)
from employees
group by department_id, job_id
order by 1,2;

-- 급여별로 사원들을 그룹화 했을 때, 각 급여별 사원수를 조회하기
select trunc(salary,-3) salary_grade, count(*)
from employees
group by trunc(salary, -3)
order by 1,2;

select salary/5000
from employees;

-- 급여별 사원수를 조회하기
select (trunc(salary/5000) + 1)*5000 || '미만' sal, count(*)
from employees
group by trunc(salary/5000)
order by trunc(salary/5000);

-- 부서별 사원수를 조회했을 때 사원수가 5미만인 부서의 아이디와 사원수를 조회하기
select department_id, count(*)
from employees
group by department_id
having count(*) < 5
order by 1,2;

-- 2007년에 입사한 사원들의 수를 직종아이디를 기준으로 집계했을 때
-- 3명이상 채용된 직종의 아이디와 사원수를 조회하기
select job_id, count(*)
from employees
where hire_date >= to_date('2007/01/01') and hire_date < to_date('2008/01/01')
group by job_id
having count(*) >= 3
order by job_id;

-- 부서별 사원수를 집계했을 대 사원수가 10명 이상인 부서의 아이디, 사원수를 조회하기
select department_id, count(*)
from employees
group by department_id
having count(*) >= 10;

-- with 절을 사용해서 쿼리의 실행속도를 개선 및 쿼리의 가독성을 높인다.
with employees_count
as (
    select department_id, dept_id, count(*) cnt
    from employees
    group by department_id
)
select A.dept_id, B.department_name, A.cnt
from employees_count A, departments B
where A.dept_id = B.department_id
and A.cnt >= 5
order by A.dept_id;

-- 테이블에 저장된 각 행들의 rowid조회하기
select rowid, department_id, department_name
from departments;

select rowid, employee_id, first_name
from employees;

create sequence product_seq
start with 1
nocache;

-- 상품테이블 생성하기
create table sample_products  (
	product_no 					number(8) 		primary key ,
	product_name 				varchar2(200) 	not null,
	product_maker				varchar2(100)   not null,
	product_category			varchar2(100)   not null,
	product_price 				number(8)		not null,
	product_discount_price 		number(8)		not null,
	product_stock				number(5)		default 100,
	product_sold_out			char(1)			default 'N',
	product_created_date		date			default sysdate
);

drop table sample_products;

-- 상품 테이블에 상품정보 저장하기
insert into sample_products
(product_no, product_name, product_maker, product_category, product_price, product_discount_price)
values 
(product_seq.nextval, 'iphone12 plus', 'apple', '스마트폰', 1400000, 1200000);

-- 새로운 일련번호 조회하기
select product_seq.nextval from dual;

-- 현재 시퀀스의 일련번호 조회하기
select product_seq.currval from dual;
