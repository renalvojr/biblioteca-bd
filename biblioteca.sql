-- Criação das tabelas
CREATE TABLE Autores (
    autor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50),
    data_nascimento DATE
);

CREATE TABLE Livros (
    livro_id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo VARCHAR(200) NOT NULL,
    autor_id INTEGER,
    ano_publicacao INTEGER,
    isbn VARCHAR(13),
    quantidade_copias INTEGER DEFAULT 1,
    FOREIGN KEY (autor_id) REFERENCES Autores(autor_id)
);

CREATE TABLE Usuarios (
    usuario_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(15),
    data_cadastro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Emprestimos (
    emprestimo_id INTEGER PRIMARY KEY AUTOINCREMENT,
    livro_id INTEGER,
    usuario_id INTEGER,
    data_emprestimo DATE DEFAULT CURRENT_DATE,
    data_devolucao_prevista DATE,
    data_devolucao_real DATE,
    FOREIGN KEY (livro_id) REFERENCES Livros(livro_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
);

-- Innserindo dados nas tabelas:
-- Tabela Autores
INSERT INTO Autores (nome, nacionalidade, data_nascimento) VALUES
('George Orwell', 'Britânica', '1903-06-25'),
('Gabriel García Márquez', 'Colombiana', '1927-03-06'),
('Agatha Christie', 'Britânica', '1890-09-15'),
('Jane Austen', 'Britânica', '1775-12-16'),
('William Shakespeare', 'Britânica', '1564-04-23'),
('Franz Kafka', 'Tcheca', '1883-07-03'),
('Fiódor Dostoiévski', 'Russa', '1821-11-11'),
('Virginia Woolf', 'Britânica', '1882-01-25'),
('Albert Camus', 'Francesa', '1913-11-07'),
('J.R.R. Tolkien', 'Britânica', '1892-01-03');

-- Tabela Livros
INSERT INTO Livros (titulo, autor_id, ano_publicacao, isbn, quantidade_copias) VALUES
('1984', 1, 1949, '9780451524935', 7),
('Cem Anos de Solidão', 2, 1967, '9780060883287', 5),
('Assassinato no Expresso do Oriente', 3, 1934, '9780062073501', 6),
('Orgulho e Preconceito', 4, 1813, '9780553213102', 4),
('Hamlet', 5, 1603, '9780521618748', 8),
('A Metamorfose', 6, 1915, '9780141184746', 4),
('Crime e Castigo', 7, 1866, '9780143058144', 5),
('Mrs. Dalloway', 8, 1925, '9780156628709', 3),
('O Estrangeiro', 9, 1942, '9780679720201', 4),
('O Senhor dos Anéis: A Sociedade do Anel', 10, 1954, '9780261103573', 6),
('O Senhor dos Anéis: As Duas Torres', 10, 1954, '9780261103580', 6);

-- Tabela Usuarios
INSERT INTO Usuarios (nome, email, telefone) VALUES
('Carlos Pereira', 'carlos@email.com', '11966554433'),
('Fernanda Costa', 'fernanda@email.com', '11955443322'),
('Pedro Souza', 'pedro@email.com', '11944332211'),
('Juliana Lima', 'juliana@email.com', '11933221100'),
('Rafael Nunes', 'rafael@email.com', '11922110099'),
('Beatriz Mendes', 'beatriz@email.com', '11911009988'),
('Rodrigo Alves', 'rodrigo@email.com', '11900998877'),
('Larissa Rocha', 'larissa@email.com', '11998877665'),
('Marcelo Ribeiro', 'marcelo@email.com', '11987766554'),
('Sofia Martins', 'sofia@email.com', '11976655443');

-- Tabela Emprestimos
INSERT INTO Emprestimos (livro_id, usuario_id, data_emprestimo, data_devolucao_prevista) VALUES
(4, 4, '2024-03-12', '2024-03-26'),
(5, 5, '2024-03-14', '2024-03-28'),
(6, 6, '2024-03-16', '2024-03-30'),
(7, 7, '2024-03-18', '2024-12-01'),
(8, 8, '2024-03-20', '2024-04-03'),
(9, 9, '2024-03-22', '2024-12-05'),
(10, 10, '2024-03-24', '2024-04-07'),
(3, 4, '2024-03-12', '2024-03-26'),
(11, 5, '2024-03-14', '2024-03-28'),
(12, 6, '2024-03-16', '2024-12-30');

-- Atualização de devoluções
UPDATE Emprestimos SET data_devolucao_real = '2024-03-25' WHERE emprestimo_id = 1;
UPDATE Emprestimos SET data_devolucao_real = '2024-03-20' WHERE emprestimo_id = 2;