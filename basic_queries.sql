-- =====================================================
-- SQL PRACTICE: Примеры запросов для анализа данных
-- =====================================================

-- ----------------------
-- УРОВЕНЬ 1: Базовые запросы
-- ----------------------

-- 1. Выбрать все данные из таблицы
SELECT * FROM employees;

-- 2. Выбрать конкретные колонки
SELECT first_name, last_name, salary FROM employees;

-- 3. Фильтрация по условию
SELECT * FROM employees WHERE salary > 70000;

-- 4. Фильтрация с несколькими условиями
SELECT * FROM employees WHERE department_id = 2 AND salary > 70000;

-- 5. Сортировка результатов
SELECT first_name, salary FROM employees ORDER BY salary DESC;

-- 6. Ограничение количества строк
SELECT * FROM employees ORDER BY hire_date DESC LIMIT 5;

-- 7. Уникальные значения
SELECT DISTINCT department_id FROM employees;

-- 8. Поиск по шаблону
SELECT * FROM employees WHERE last_name LIKE 'J%';

-- 9. Проверка на пустые значения
SELECT * FROM employees WHERE first_name IS NULL;

-- ----------------------
-- УРОВЕНЬ 2: JOIN и агрегация
-- ----------------------

-- 10. INNER JOIN (только совпадающие записи)
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- 11. LEFT JOIN (все сотрудники, даже без отдела)
SELECT e.first_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- 12. COUNT() - подсчет количества
SELECT COUNT(*) FROM employees;

-- 13. SUM() - сумма
SELECT SUM(salary) FROM employees WHERE department_id = 1;

-- 14. AVG() - среднее
SELECT AVG(salary) FROM employees;

-- 15. GROUP BY - группировка
SELECT department_id, COUNT(*) as employee_count
FROM employees
GROUP BY department_id;

-- 16. HAVING - фильтрация после группировки
SELECT department_id, AVG(salary) as avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 70000;

-- 17. CASE - условная логика
SELECT first_name, salary,
    CASE
        WHEN salary > 85000 THEN 'High Earner'
        WHEN salary > 70000 THEN 'Mid Earner'
        ELSE 'Standard Earner'
    END as salary_bracket
FROM employees;

-- 18. Подзапрос (Subquery)
SELECT first_name, last_name
FROM employees
WHERE department_id IN (
    SELECT department_id 
    FROM departments 
    WHERE department_name = 'Sales'
);

-- ----------------------
-- УРОВЕНЬ 3: Продвинутые запросы (аналитика)
-- ----------------------

-- 19. CTE (Common Table Expression) - временная таблица
WITH HighSalaries AS (
    SELECT employee_id, first_name, salary
    FROM employees
    WHERE salary > 75000
)
SELECT * FROM HighSalaries;

-- 20. ROW_NUMBER() - нумерация строк
SELECT
    first_name,
    department_id,
    salary,
    ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary DESC) as rank_in_dept
FROM employees;

-- 21. RANK() - ранжирование с пропусками
SELECT
    first_name,
    salary,
    RANK() OVER(ORDER BY salary DESC) as salary_rank
FROM employees;

-- 22. LAG() - доступ к предыдущей строке
-- (пример для таблицы sales с полями sale_date, sale_amount)
SELECT
    sale_date,
    sale_amount,
    LAG(sale_amount, 1, 0) OVER(ORDER BY sale_date) as previous_day_sales
FROM sales;

-- 23. Скользящее среднее (moving average)
SELECT
    sale_date,
    sale_amount,
    AVG(sale_amount) OVER(ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as three_day_moving_avg
FROM sales;

-- 24. Анализ когорт (cohort analysis)
-- Пример: Retention по месяцам регистрации
SELECT
    DATE_TRUNC('month', signup_date) AS cohort_month,
    COUNT(DISTINCT user_id) AS users
FROM users
GROUP BY cohort_month
ORDER BY cohort_month;

-- 25. Доля от общего (percentage of total)
SELECT
    department_id,
    COUNT(*) as employees,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) as percentage
FROM employees
GROUP BY department_id;
