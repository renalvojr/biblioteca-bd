-- Consultas:

-- 1. Listar todos os livros
SELECT * FROM Livros;

-- 2. Listar todos os livros com seus respectivos autores
SELECT l.titulo, a.nome as autor, l.ano_publicacao
FROM Livros l
JOIN Autores a ON l.autor_id = a.autor_id;

-- 3. Total de livros por autor
SELECT a.nome, COUNT(l.livro_id) as total_livros
FROM Autores a
LEFT JOIN Livros l ON a.autor_id = l.autor_id
GROUP BY a.autor_id, a.nome;

-- 4. Livros disponíveis para empréstimo
SELECT l.titulo, 
       l.quantidade_copias - COUNT(CASE WHEN e.data_devolucao_real IS NULL THEN 1 END) as copias_disponiveis
FROM Livros l
LEFT JOIN Emprestimos e ON l.livro_id = e.livro_id
GROUP BY l.livro_id, l.titulo, l.quantidade_copias
HAVING copias_disponiveis > 0;

-- 5. Livros mais emprestados
SELECT l.titulo, COUNT(e.emprestimo_id) AS total_emprestimos
FROM Livros l
JOIN Emprestimos e ON l.livro_id = e.livro_id
GROUP BY l.livro_id, l.titulo
ORDER BY total_emprestimos DESC;

-- 6. Verificar empréstimos ativos e status de devolução
SELECT u.nome as usuario, l.titulo, 
       e.data_emprestimo, 
       e.data_devolucao_prevista,
       CASE 
           WHEN e.data_devolucao_real IS NULL AND date('now') > e.data_devolucao_prevista 
           THEN 'Atrasado'
           WHEN e.data_devolucao_real IS NULL 
           THEN 'Em andamento'
           ELSE 'Devolvido'
       END as status
FROM Emprestimos e
JOIN Usuarios u ON e.usuario_id = u.usuario_id
JOIN Livros l ON e.livro_id = l.livro_id;

-- 7. Usuários com mais empréstimos
SELECT u.nome, COUNT(e.emprestimo_id) as total_emprestimos
FROM Usuarios u
LEFT JOIN Emprestimos e ON u.usuario_id = e.usuario_id
GROUP BY u.usuario_id, u.nome
ORDER BY total_emprestimos DESC;

-------------------------------------

-- 8. Inserir novo livro
INSERT INTO Livros (titulo, autor_id, ano_publicacao, isbn, quantidade_copias)
VALUES ('Memórias Póstumas de Brás Cubas', 1, 1881, '9788535910699', 3);

-- 9. Inserir novo empréstimo
INSERT INTO Emprestimos (livro_id, usuario_id, data_emprestimo, data_devolucao_prevista)
VALUES (1, 2, date('now'), date('now', '+14 days'));

-- 10. Atualizar devolução de livro
UPDATE Emprestimos 
SET data_devolucao_real = date('now')
WHERE emprestimo_id = 1;

-- 11. Buscar livro específico
SELECT 
    l.titulo,
    a.nome as autor,
    l.quantidade_copias
FROM Livros l
JOIN Autores a ON l.autor_id = a.autor_id
WHERE l.titulo LIKE '%Dom%';