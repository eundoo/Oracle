-- departments 테이블의 모든 행, 모든 컬럼 조회하기
select *
from departments;

-- employees 테이블의 모든 행, 모든 컬럼 조회하기
select *
from employees;

-- jobs 테이블의 모든 헹, 모든 컬럼 조회하기
select *
from jobs;

-- locations 테이블의 모든 행, 모든 컬럼 조회하기
select *
from locations;

-- 테이블에서 지정된 컬럼만 조회하기
-- employee 테이블에서 사원아이디, 이름, 급여를 조회하기
select employee_id, first_name, salay
from employees;

-- employees테이블에서 사원아이디, 이름, 직종아이디 조회하기
select employee_id, first_name, department_id     -- select절
from employees;                                   -- from  절
-- departments테이블에서 부서아이디, 부서명 조회하기
select demartment_id, department_name
from departments;
-- jobs 테이블에서 직종아이디, 최소급여, 최대급여 조회하기
select job_id, min_salay, max_salay
from jobs;
-- locations 테이블에서 위치아이디, 주소, 도시명 조회하기
select location_id, street_address, pastal_code
from locations;

-- employees 테이블에서 소속부서 아이디, 상사의 사원아이디, 사원의 이름 조회하기
select departmetn_id, manager_id, first_name
from employees;

-- 조회결과에 중복된 값이 있을 때 중복된행을 제거하고 조회하기
select distinct job_id
from employees;

-- employees에 등록된 사원들의 소속부서 아이디를 조회하기
select distinct department_id
from employees;

-- job_history 테이블을 조회해서 직종이 변경된 적이 있는 사원의 아이디를 조회하기
select distinct employee_id
from job_history;

-- 연결 연산자를 이용해서 두 개 이상의 컬럼값을 붙여서 조회하기
select employee_id, first_name, last_name, first_name ||' '|| last_name
from employees;

-- 조회 결과에 별칭을 붙여서 조회하기
select employee_id, first_name || ' ' || last_name as full_name
from employees;

select employee_id, first_name || ' ' || last_name name
from employess;
select employee_id, first_name || ' ' || last_name as name
from employess;
select employees employee_id, first_name || ' '|| last_name name
from employees;

--사칙연산자 사용하기
--employees 테이블에서 사원아이디, 이름,주급,월급 조회하기
select employee_id, first_name, salary,salary*4,salary_of_month
from employees;

-- jobs 테이블에사 직종아이디, 최소급여, 최대급여, 최소급여와 최대급여의 차이를 조회
select job_id, min_salary, max_salary, max_salary - min_salary as salary_gap
from jobs;

-- where절을 이용해서 조회하는 행을 제한
-- employee의 사원아이디가 100인 사원인 아이디, 이름, 급여를 조회
-- 100번만 true 나머지는 false가됨
select employee_id, first_name, salary
from employees
where employee_id = 100;

-- 이름이 Steven인 사원의 사원아이디, 이름, 직종아이디, 급여를 조회
select employee_id, first_name, job_id, salary
from employees
where first_name = 'Steven'; --텍스트 값은 대소문자를 구분

-- 급여가 3000이하인 사원의 사원아이디, 이름, 직종아이디, 급여를 조회
select employee_id, first_name, job_id, salary
from employees
where salary <= 3000;

-- 급여가 2500이하인 사원의 사원아이디, 이름, 직종아이디, 급여를 조회
select employee_id, first_name, job_id, salary
from employees
where salary <= 2500;

-- 급여를 15000달러 이상인 사원의 사원아이디, 이름, 직종아이디, 급여를 조회
select employee_id, first_name, job_id, salary
from employees
where salary >= 15000;

-- 급여가 10000이상인 사원의 이름, 급여를 조회하기
-- 조회결과는 이름에 대한 오름차순으로 정렬하기
select first_name, salary
from employees
where salary >= 10000 
order by first_name asc;

-- 급여가 10000이상인 사원의 이름, 급여를 조회하기
-- 조회결과는 급여에 대한 내림차순으로 정렬하기
select first_name, salary
from employees
where salary >= 10000
order by salary asc;

-- 급여가 10000이상인 사원의 이름, 급여를 조회하기
-- 조회결과는 급여에 대한 내림차순으로 정렬하기
-- 급여가 같을시 ABC기준
select first_name, salary
from employees
where salary >= 10000
order by salary desc, first_name asc;