-- Практична робота 16 — Варіант 1: Бібліотека
-- Цільова таблиця: books. Початково 7 рядків (6 з практики 1 + Test DEFAULT з практики 5).

-- Завдання 1: підрахунок до імпорту
SELECT COUNT(*) AS before_import FROM books; -- 7

-- Завдання 2: staging table (без id)
CREATE TABLE books_staging (
    title TEXT,
    author TEXT,
    publication_year INTEGER,
    genre TEXT,
    copies_count INTEGER
);

-- Для CLI sqlite3 виконайте окремо:
-- .mode csv
-- .import --skip 1 v1_new_rows.csv books_staging
-- Перевірка staging:
SELECT * FROM books_staging;


-- Для автономного запуска SQL у DB Browser можна заповнити staging таким чином:
INSERT INTO books_staging (title, author, publication_year, genre, copies_count) VALUES
('Енеїда', 'Іван Котляревський', 1798, 'Поезія', 3),
('Чорна рада', 'Пантелеймон Куліш', 1857, 'Історичний роман', 2),
('Аліса в Країні див', 'Льюїс Керрол', 1865, 'Фантастика', 4),
('1984', 'Джордж Орвелл', 1949, 'Антиутопія', 3),
('Гаррі Поттер і філософський камінь', 'Дж. К. Ролінґ', 1997, 'Фентезі', 5),
('Маленький принц', 'Антуан де Сент-Екзюпері', 1943, 'Повість', 4),
('Пригоди Тома Сойєра', 'Марк Твен', 1876, 'Пригоди', 2),
('Повія', 'Панас Мирний', 1883, 'Роман', 1);


-- Завдання 3: перенесення (виконується після імпорту staging)
INSERT INTO books (title, author, publication_year, genre, copies_count)
SELECT title, author, publication_year, genre, copies_count
FROM books_staging;

DROP TABLE books_staging;

SELECT COUNT(*) AS after_import FROM books; -- 15, приріст 8

-- Завдання 4: перевірка нових рядків
SELECT id, title, author, publication_year, genre, copies_count
FROM books
WHERE title IN (
 'Енеїда', 'Чорна рада', 'Аліса в Країні див', '1984',
 'Гаррі Поттер і філософський камінь', 'Маленький принц',
 'Пригоди Тома Сойєра', 'Повія'
);

-- Завдання 5: прямий імпорт у books (виконувати ТІЛЬКИ у копії бази).
-- .mode csv
-- .import --skip 1 v1_new_rows.csv books
-- Очікувано: SQLite повідомляє, що у CSV 5 колонок, а books має 6,
-- значення зміщуються (title потрапляє в id) та виникають помилки datatype mismatch.

-- Контрольні питання:
-- 1. id не додають до CSV, щоб SQLite сама призначала унікальні ключі.
--    Довільні id можуть повторити наявні та спричинити UNIQUE/PK помилку.
-- 2. DROP TABLE видаляє staging, щоб при повторному імпорті старі записи
--    не перенеслися вдруге. Залишати таблицю можна, але потрібно очищати її.
-- 3. COUNT(*) дає точне число і дозволяє перевірити, що приріст дорівнює 8.
