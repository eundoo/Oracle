-- 테이블 조인하기
-- 사원아이디, 소속부서아이디, 소속부서명
-- employee테이블 -> 사원아이디, 사원명, 소속부서 아이디
-- departments 테이블 - 소속부서명

select employeses.employee_id, employees.first_name, employees.department_id,
        departments.department_name
from employees, departments
where employees.department_id = departments.department_id;

select A.employee_id, A.first_name, A.department_id, B.department_name
from employees A, departments B
where A.department_id = B.department_id;

-- 테이블 조인하기
-- 사원아이디, 이름, 직종아이디, 급여, 직종제목, 직종 치소급여, 직종 최대급여 적용하기
-- employees 테이블 -> 사원아이읻, 이름, 직종아이디, 급여
-- jobs 테이블 -> 직종아이디, 직종제목, 직종 최적급여, 직종 최고급여 -> 얘를 제일먼저 파악해야 조인일건지 뭔지 알 수 있다.
select A.employee_id, A.frist_name, A.salary, A.job_id B.min_salary, B.max_salary
from employees A, jobs B
where A.job_id = B.job_id;

-- 테이블 조인하기
-- 부서아이디, 부서명, 소재지아이디, 소재지주소, 소재지 도시명 조회하기
-- departments -> 부서아이디, 부서명, 소재지아이디
-- locations -> 소재지주소, 소재지 도시명
select A.department_id, A.department_name, B.location_id, B.street_address, B.city
from departments A, locations B
where A.location_id = B.location_id;

-- 테이블 조인하기
-- 부서관리자가 지정되어있는 부서의 부서아이디, 부서명, 부서관리자 아이디, 부서관리자 이름조회
-- departments -> 부서아이디, 부서명, 부서관리자아이디,
-- employees -> 부서관리자이름(사원이름)
-- departments의 manager_id는 부서관리자로 지정된 사원의 아이디이다.
-- departments의 manager_id와 동일한 사원아이디를 가진 사원정보가 조인되어야 한다.
select A.department_id, A.department_name, A.manager_id, B.first_name
from departments A, employees B
where A.manager_id = B.employee_id
and A.manager_id is not null;

-- 3개 이상의 테이블 조인하기
-- 사원아이디, 사원이름, 직종아이디, 급여, 직종최저급여, 직종최고급여, 소속부서 아이디, 부서명
-- employees -> 사원아이디, 사원이름, 직종아이디, 급여, 소속부서 아이디
-- jobs -> 직종최저급여, 직종최고급여
-- departments -> 부서명
select *
from employees E, jobs J, departments D
where E.job_id = J.job_id and E.department_id = D.department_id
order by E.employee_id asc;

-- 100번 사원의 이름, 전화번호, 이메일,
-- 소속부서의 아이디, 소속부서명, 소속부서 도시명, 소속부서 소재지 주소 조회하기
select E.first_name, E.phone_number, E.email, D.department_id, D.department_name,
        L.ciry, l.street_address;
from employees E, departments D, locations L
where E.employee_id = 100 --검색조건
and E.department_id = D.department_id
and D.location_id = L.location_id;

-- 50번 부서에 소속된 사원들의 사원아이디, 이름, 직종아이디, 직종제목 조회하기
-- 사원아이디, 이름, 직종아이디 -> employees
-- 직종제목 -> jobs
select E.employee_id, E.first_name, J.job_id, J.job_title
from employees E, jobs J
where E.department_id = 50
and E.job_id = J.job_id;

-- 급여를 15000이상 받은 사원들의 이름, 직종아이디, 급여, 부서명을 조회하기
-- 급여, 이름, 직종아이디, -> employees 
-- 부서명 -> departments
select E.first_name, E.job_id, E.salary, D.department_name
from employees E, departments D
where E.salary >= 15000
and E.department_id = D.department_id;

-- 100번 직원 직원이 관리하는 사원들의 이름, 
-- 직종아이디, 직종제목, 부서아이디, 부서명 조회하기
-- 100번 직원, 이름, 직종아이디, 부서아이디 --> employees
-- 직종제목 --> jobs
-- 부서명 --> depertments
select E.first_name, J.job_id, J.job_title, 
        D.department_id, D.department_name
from employees E, jobs J, departments D
where E.employee_id = 100
and E.job_id = J.job_id
and E.department_id = D.department_id;

-- 모든 사원들의 사원아이디, 이름, 소속부서아이디, 소속부서명을 조회하기
select E.employee_id, E.first_name, E.department_id, D.department_name
from employees E, departments D
where E.department_id = D.department_id;
-- 모든 사원들의 사원아이디, 이름, 직종아이디, 직종제목을 조회하기
select E.employee_id, E.first_name, E.job_id, J.job_title
from employees E, jobs J
where E.job_id = J.job_id;
-- 사원들 중에서 소속부서가 정해지지 않는 사원의 아이디, 이름, 급여, 직종, 직종최소급여, 직종최대급여를 조회하기
select E.employee_id, E.first_name, E.salary, E.job_id, J.min_salary, J.max_salary
from employees E, jobs J
where E.department_id is not null;
-- 2007년에 입사한 사원들의 사원아이디, 이름, 소속부서아이디, 소속부서명을 조회하기???????
select E.employee_id, E.first_name, E.department_id, D.department_name, to_char(E.hire_date, 'yyyy') hireDate
from employees E, departments D, job_history JH

-- 커미션을 받은 사원들의 사원아이디, 이름, 직종, 직종제목, 소속부서아이디, 소속부서명을 조회하기
select E.employee_id, E.first_name, E.job_id, J.job_title, E.department_id, D.department_name
from employees E, jobs J, departments D
where E.commission_pct is not null
and E.job_id = J.job_id
and E.department_id = D.department_id;
-- 직종최소급여가 10000달러 이상인 직종에 종사하고 있는 사원들의 아이디, 이름, 직종아이디, 급여를 조회하기
select E.employee_id, E.first_name, E.job_id, E.salary
from employees E, jobs J 
where J.min_salary >= 10000
and E.job_id = J.job_id;
-- 모든 사원들의 사원아이디, 이름, 소속부서아이디, 소속부서명, 해당부서의 소재지 도시 및 주소를 조회하기
select E.employee_id, E.first_name, E.department_id, D.department_name, D.location_id, L.city, L.street_address 
from employees E, departments D, locations L
where E.department_id = D.department_id
and D.location_id = L.location_id;
-- 모든 사원들의 사원아이디, 이름, 직종아이디, 직종제목, 소속부서아이디, 소속부서명, 해당부서의 소재지 도시 및 주소
select E.employee_id, E.first_name, E.job_id, J.job_title, 
D.department_id, D.department_name, D.location_id, L.city, L.street_address 
from employees E, jobs J, locations L, departments D
where E.job_id = J.job_id
and D.location_id = L.location_id;
-- 부서 소재지 국가가 미국에 위치하고 있는 부서의 부서아이디, 부서명, 도시명을 조회하기
select D.department_id, D.department_name, L.country_id
from departments D, locations L
where D.location_id = L.location_id
and L.country_id ='US';
-- 'Seattle'에서 근무하고 있는 사원들의 사원아이디, 이름, 부서아이디, 부서명을 조회하기
select E.employee_id, E.first_name, E.department_id, D.department_name
from employees E, locations L, departments D
where E.department_id = D.department_id
and D.location_id = L.location_id
and L.city = 'Seattle';
-- 2006년에 job이 변경된 기록이 있는 사원들의 사원아이디, 이름, 직종아이디를 조회하기?????

-- 이전에 50번 부서에서 근무한 적이 있는 사원들의 사원아이디, 이름, 근무시작일, 근무종료일, 근무당시 직종아이디를 조회하기
select E.employee_id, E.first_name, JH.start_date, JH.end_date, JH.job_id, JH.department_id
from employees E, job_history JH
where JH.department_id = 50
and E.employee_id = JH.employee_id;
-- 사원들 중에서 자신이 근무하고있는 직종의 최소급여와 최대급여의 평균값보다 적은 급여를 받는
-- 사원의 아이디, 이름, 직종아이디, 급여, 최소급여, 최대급여, 최소/최대급여 평균값을 조회하기
-- (평균값은 (최소급여 + 최대급여) / 2 로 구한다) 
select E.employee_id, E.first_name, E.job_id, J.min_salary, J.max_salary, (J.min_salary + J.max_salary)/2 avg , E.salary
from employees E, jobs J
where E.job_id = j.job_id
and E.salary < (J.min_salary + J.max_salary)/2;