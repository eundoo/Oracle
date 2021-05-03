-- 비등가조인
-- 모든 사원들의 아이디, 이름, 급여, 급여등급을 조회하기
-- 아이디, 이름, 급여 - employees
-- 급여등급 - salary_grade
-- 사원의 급여가 급여등급정보의 최소급여 이상이고, 최대급여이하인 행과 조인
-- 이퀄이아니고 >, = 를 사용해서 크고 작고를 비교
select E.employee_id, E.first_name, E.salary, S.grade
from employees E, salary_grade s
where E.salary >= s.min_salary and E.salary <= s.max_salary
order by E.employee_id;

-- 자체조인
-- 60번 부서에 소속된 사원들의 사원아이디, 사원이름, 상사의 아이디, 상사의 이름 조회하기
-- 사원아이디, 사원이름 - employees
-- 상사의 아이디, 상사의 이름 - employees
select E.employee_id emp_id, E.first_name emp_name, M.employee_id mgr_id, M.first_name mgr_name
from employees E, employees M
where E.department_id = 60
and E.manager-id = M.employee_id;

-- 60번 부서에 소속된 사원들의 사원아이디, 사원이름, 상원의 소속부서명,
--                  상사의 아이디, 상사의 이름, 상사의 소속부서명 조회하기
-- 사원아이디, 사원이름 - employees
-- 상사의 아이디, 상사의이름 - employees
-- 사원의 소속부서명 - departments
-- 상사의 소속부서명 - departments
select E.employee_id emp_id, E.first_name emp_name,
       E.department_id edept_id, ED.department_name edept_name,
        M.employee_id mgr_id, M.first_name mgr_name,
        M.department_id mdept_id, MD.department_name mdept_name
from employees E, employees M, departments ED, departments MD
where E.department_id = 60            -- 60번 부서에 소속된 사원
and E.manager_id = M.employee_id    --사원테이블의 manager_id와 상사테이블의 employee_id조인
and E.department_id = ED.department_id
and M.department_id = MD.department_id;
