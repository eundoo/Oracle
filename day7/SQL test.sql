-- 실습해보기

-- 사원아이디, 이름, 소속부서 아이디, 소속부서명을 조회하기 O
select E.employee_id, E.first_name, E.department_id, D.department_name
from employees E, departments D
where E.department_id = D.department_id;

-- 60번부서에 소속된 사원들의 사원아이디, 이름, 급여, 직종아이디, 직종제목, 직종최저급여, 직종최고급여를 조회하기 O
select E.employee_id, E.first_name, E.salary, E.job_id, J.job_title, J.min_salary, J.max_salary
from employees E, jobs J
where E.department_id = 60
and E.job_id = J.job_id;

-- 모든 사원들의 사원아이디, 이름, 급여, 급여등급을 조회하기 O
select E.employee_id, E.first_name, E.salary, S.grade
from employees E, salary_grade S
where E.salary >= S.min_salary and E.salary <= S.max_salary
order by grade;

-- 60번부서에 소속된 사원들의 사원아이디, 이름, 상사의 이름을 조회하기 O
select E.employee_id, E.first_name, M.first_name
from employees E, employees M 
where E.department_id = 60
and E.manager_id = M.employee_id;

-- 부서관리자가 있는 부서의 부서아이디, 부서명, 부서관리자 아이디, 부서관리자이름을 조회하기 X
select E.department_id, D.department_name, D.manager_id, E.first_name 
from departments D, employees E
where D.manager_id is not null
and E.department_id = D.department_id;

-- 부서관리자가 있는 부서의 부서소재지 도시명을 중복없이 조회하기 O
select distinct D.location_id, L.city
from departments D , locations L
where D.manager_id is not null
and D.location_id = L.location_id;

-- 소속부서명이 'Sales'이고, 급여등급이 'A'나 'B'에 해당하는 사원들의 아이디, 이름, 급여, 급여등급을 조회하기 X
-- ?????


-- 60번 부서에 소속된 사원들의 평균급여를 조회하기 O
select avg(salary)
from employees E
where department_id = 60;

-- 직종아이디별 사원수를 조회하기 X
select J.job_id, count(*)
from jobs J, employees E
where E.job_id = J.job_id
group by J.job_id;

-- 급여 등급별 사원수를 조회하기 O
select S.grade, count(*)
from employees E, salary_grade S
where E.salary <= S.min_salary and E.salary <= S.max_salary
group by S.grade;

-- 2007년 입사한 사원들의 월별 입사자 수를 조회하기 X
-- ?????
select count(*)
from employees E
where E.hire_date >= to_date(2007/01/01) and E.hire_date < to_date(2008/01/01)
group by substr(E.hire_date,6,2);



-- 정답
-- 사원아이디, 이름, 소속부서 아이디, 소속부서명을 조회하기
select E.employee_id, E.first_name, D.department_id, D.department_name
from employees E, departments D
where E.department_id = D.department_id;

-- 60번부서에 소속된 사원들의 사원아이디, 이름, 급여, 직종아이디, 직종제목, 직종최저급여, 직종최고급여를 조회하기
select E.employee_id, E.first_name, E,salary, J.job_id, J.job_title, J.min_salary, J.max_salary
from employees E, jobs J
where E.department_id = 60
and E.job_id = J.job_id;

-- 모든 사원들의 사원아이디, 이름, 급여, 급여등급을 조회하기
select  E.employee_id, E.first_name, E.salary, G.grade
from employees E, salary_grade G
where E.salary >= G.min_salary and E.salary <= G.max_salary
order by E.employee_id;

-- 60번 부서에 소속된 사원들의 사원아이디, 이름, 상사의 이름을 조횧기
select E.department_id, E.first_name employee_name, M.first_name manager_name
from employees E, employees M
where E.department_id = 60
and E.manager_id = M.employee_id;

-- 부서관리자가 있는 부서의 부서아이디, 부서명, 부서관리자 아이디, 부서관리자 이름을 조회하기
select D.department_id, D,department_name, D.manager_id, E.first_name manager_name
from departments D, employees E
where D.manager_id is not null
and D.manager_id = E.employee_id;

-- 부서관리자가 있는 부서의 부서소재지 도시명을 중복없이 조회하기
select distinct L.city
from departments D, locations L
where D.manager_id is not null
and D.location_id = L.location_id;

-- 소속부서명이 'Salas'이고, 급여등급이 'A'나 'B'에 해당하는 사원들의 아이디, 이름, 급여, 급여등급을 조회하기
select E.employee_id, E.first_name, E.salary, G.grade
from departments D, salary_grade G, employees E
where D.department_name = 'Sales'       -- 소속부서명이 'Sales'인 행
and D.department_id = E.department_id   -- 소속부서명이 'Sales'인 행의 부서아이디와 같은 부서아이디를 가진 사원
and E.salary >= G.min_salary and E.salary <= G.max_salary -- 사원의 급여와 급여 등급 정보를 조인
and (G.grade = 'A' or G.grade = 'B');                            -- 급여등급이 'A' 나 'B'인 경우

-- 60번 부서에 소속된 사원들의 평균급여를 조회하기
select avg(salary) avg_salary
from employees
where department_id = 60;

-- 직종아이디 별 사원수를 조회하기
select job_id
from employees
group by job_id;

-- 급여 등급별 사원수를 조회하기
select G.grade, count(*) cnt
from employees E, salary_grade G
where E.salary >= G.min_salary and E.salary <= G.max_salary
group by G.grade
order by G.grade asc;

-- 2007년 입사한 사원들의 월별 입사자 수를 조회하기
select to_char(hire_date,'mm') month, count(*) cnt
from employees
where hire_date >= to_date('2007/01/01') and hire_date <= to_date('2008/01/01') 
group by to_char(hire_date,'mm')
order by hire_month;