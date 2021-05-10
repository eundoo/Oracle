-- 일반 서브쿼리
-- 서브쿼리가 먼저 딱 한번 실행되고, 메인 쿼리가 실행된다.

-- 60번 부서의 평균급여보다 많은 급여를 받는 사원을 조회하기
select O.employee_id, O.first_name, O.salary
from employees O
where O.salary > (select avg(I.salary)
                    from employees I
                    where I.department_id = 60);
                    
-- 상호연관 서브쿼리
-- 서브쿼리안에서 메인 쿼리의 컬럼이 사용되는 서브쿼리다.
-- 메인쿼리가 실행될 때마다 서브쿼리가 실행된다.
-- 상호연관 서브쿼리는 조회된 행의 갯수만큼 실행된다.

-- 자신이 소속되어 있는 부서의 평균급여보다 급여를 많이 받은 사원을 조회하기
select O.employee_id, O.first_name, O.salary
from employees O
where O.salary > (select avg(I.salary)
                    from employees I
                    where I.department_id = O.department_id);
                                            --밖에 있는 사원이 여기 O.department_id에 전달된다.
     
-- 사용자 아이디, 이름, 급여, 자신이 소속된 부서의 평균급여 조회하기
select O.employee_id, O.first_name, O.department_id, O.salary,
        (select trunc(avg(I.salary))
        from employees I
        where I.department_id = O.department_id) avg_salary
from employees O;

-- 부서아이디, 부서명, 소속된 사원수를 조회하기 (group by를 써도 되지만)
select O.department_id, O.department_name, 
        (select count(*)
         from employees I
         where I.department_id= O.department_id) as employee_cnt
from departments O;

-- 부서아이디, 부서명, 해당부서의 관리자 이름, 소속된 사원수를 조회하기
select O.department_id, O.department_name,
        (select I.frist_name
         from employees I
         where I.employee_id = O.manager_id) as manager_name,
         (select count(*)
         from employees I
         where I.department_id = O.department_id) as employee_cnt
from departments O;

-- 스칼라 서브쿼리
-- 서브쿼리의 실행결과가 단일행-단일컬럼인 경우(오직 값이 하나만 조회되는 서브쿼리)
-- 값이 하나만 나오는 쿼리 즉 스칼라쿼리는 셀렉트절에 적을 수 있다.
-- 사원아이디, 이름, 급여, 사원전체평균급여 조회하기
select O.employee_id, O.first_name, O.salary, 
        (select trunc(avg(I.salary)) from employees I) avg_salary
from employees O;

-- 스칼라 서브쿼리를 update문에서 사용하기
-- 사원의 급여를 전체사원의 평균급여의 10%만큼 인상시키기
update employees
set
    salary = salary + (select trunc(avg(salary)*0.1) from employees);
-- 스칼라 서브쿼리를 insert문에서 사용하기
-- 새로운 사원정보를 추가하기
insert into employees
(employee_id, first_name, last_name, email, phone_number,
hire_date, job_id, salary, commission_pct, manager_id, department_id)
values 
(employees_seq.nextval, 'Gildoing', 'hong', 'GILDOING', '010.1111.2222',
sysdate, 'IT_PROG', (select min_salary from jobs where job_id = 'IT_PROG'), null, 103, 60);

-- 뷰 (가상의테이블)
-- 부서 상세정보를 제공하는 가상의 테이블 생성하기
-- 부서 상세정보 - 부서아이디, 부서명, 관리자 아이디, 관리자 이름,
-- 부서에 소속된 사원수, 부서의 소재지, 주소
create or replace view departments_detail_view
as
select D.department_id, D.department_name, D.manager_id, E.first_name, E.last_name,
       L.city, L.street_address,
       (select count(*) from employees I where I.department_id = D.department_id) emp_cnt
from departments D, employees E, locations L
where D.manager_id = E.employee_id(+)
and D.location_id = L.location_id;

-- 60번 부서의 상세정보 조회하기
-- view 사용하기 전
select D.department_id, D.department_name, D.manager_id, E.first_name, E.last_name,
       L.city, L.street_address,
       (select count(*) from employees I where I.department_id = D.department_id) emp_cnt
from departments D, employees E, locations L
where D.department_id = E.employee_id(+)
and D.location_id = L.location_id
and D.department_id = 60;
-- view 사용 후
-- 위를 view를 활용하면 위처럼 적어야 될걸 이렇게 간략하게 할 수 있다.
select department_id, department_name, manager_id, first_name, last_name, city, street_address, emp_cnt
from departments_detail_view
where department_id = 60;

-- 사원의 상세정보를 제공하는 뷰 생성하기
-- 사원아이디, 이름, 이메일, 전화번호, 입사일, 근무개월수, 근무년수, 급여, 커미션, 급여등급,
-- 연봉, 상사의 아이디, 상사이름, 직종아이디, 직종제목, 부서아이디, 부서명, 부서관리자이름
create or replace view employees_detail_view
as
select E.employee_id as emp_id,
    E.first_name || ',' || E.last_name as full_name,
    E.email, 
    E.phone_number, 
    E.hire_date, 
    trunc(months_between(sysdate, E.hire_date)) work_months,
    trunc(months_between(sysdate, E.hire_date)/12) working_year,
    E.salary, 
    E.commission_pct, 
    G.grade, 
    E.salary*12+E.salary*12*nvl(E.commission_pct, 0) annual_salary,
    M.employee_id as manager_id,
    M.first_name || ',' || M.last_name as manager_name,
    E.job_id,
    J.job_title,
    E.department_id,
    D.department_name,
    DM.first_name || ',' || DM.last_name as dept_manager_name
from employees E, salary_grade G, employees M, jobs J, departments D, employees DM
where E.salary >= G.min_salary and E.salary <= G.max_salary
and E.manager_id = M.employee_id(+)
and E.job_id = J.job_id
and E.department_id = D.department_id
and D.manager_id = DM.employee_id(+);

-- 오후

-- 200사원의 아이디, 이름, 급여, 급여등급, 연봉, 직종아이디, 소속부서명을 조회
select emp_id, full_name, salary, grade, annual_salary, job_id, department_name
from employees_detail_view
where emp_id = 200;
-- 별도의 join작업이 필요없다 이미 조인된걸 다 만들어 놔서 거기서 가져오면 된다.

-- 급여등급별 사원수를 조회하기
select grade, count(*)
from employees_detail_view
group by grade
order by grade;
-- 입사일 기준 근무년수가 15년 이상인 사원의 아이디, 이름, 입사일, 근무년수를 조회하기
select emp_id, full_name, hire_date, working_year
from employees_detail_view
where working_year >= 15
order by working_year desc;
-- 연봉이 10만불 이상인 사원의 아이디, 이름, 급여, 급여등급, 연봉, 직종을 조회하기
select emp_id, full_name, salary, grade, annual_salary, job_id
from employees_detail_view
where annual_salary >= 200000;

-- create or replace view 뷰이름
-- 뷰(데이터 베이스 객체 생성)
-- 전원이 꺼져도 유지된다.
create or replace view 뷰이름
as 
select col1, col2, ...
from table1, table2
where table1.col = table2.col;

-- 인라인뷰 (데이터 베이스 객체 아님)
-- SQL이 실행되는 동안만 유지됨

select A.col1, Acol2, B.col1, B.col2, ...
from (select col1, col2, ...
        from table1
        where col = 값) A, table2 B
where A.col = B.col

--인라인 뷰 **엄청엄청 유용함
--직종별 사원수를 조회하기
--직종아이디, 직종제목, 직종 최소급여, 직종 최대급여, 사원수
--select job_id, count(*)
--from employees
--group job_id
select A.job_id, B.job_title, B.min_salary, B.max_salary, A.cnt
from (select job_id, count(*) cnt -- 별칭을 꼭 적어야된다. 별칭을 컬럼명처럼 select에서 사용 할 수 있으니끼
        from employees
        group by job_id) A, jobs B  --이런 가상의 테이블이 있다고 보는거다.
where A.job_id = B.job_id;

-- Top-N 분석 -- top3.. top2..이런거처럼
-- 지정된 컬럼의 값을 기준으로 행을 정렬하고, 상위N개의 열을 조회하는 것

-- 연봉에 대한 내림차순으로 정렬했을 때 상위 3명의 아이디, 이름, 연봉을 조회하기
select
from (select emp_id, full_name, annual_salary
        from employees_detail_view
            order_by annual_salary desc) --나는 무슨순서로 정렬을하고 top-n을 구할건지 먼저 정렬하는거
where rownum <= 3;

-- 직종별 인원수를 조회했을 때, 인원수가 가장 많은 직종 3개를 조회하기 
select rownum, job_id, cnt
from (select job_id, count(*) cnt
        from employees
        group by job_id;
        order by cnt dest)
where rownum <= 3;

-- 직종별 인원수를 조회했을 때, 인원수를 기준으로 내림차순 정렬하고, 6번째~10번째에 해당하는
-- 행을 조회하기
select ranking, job_id, cnt
from (select rownum ranking, job_id, cnt
      from (select job_id, count(*) cnt
            from employees
            group by job_id
            order by cnt desc))
where ranking >= 6 and ranking <= 10; --select문의 실행결과를 가상의 테이블로 간주하고 실행하기 inline-view