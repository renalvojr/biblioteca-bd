import sqlite3
from tabulate import tabulate
from datetime import datetime

class BibliotecaDB:
    def __init__(self, db_file):
        self.db_file = db_file
        self.conn = None
        self.cursor = None

    def conectar(self):
        """Estabelece conexão com o banco de dados"""
        self.conn = sqlite3.connect(self.db_file)
        self.cursor = self.conn.cursor()

    def desconectar(self):
        """Fecha a conexão com o banco de dados"""
        if self.conn:
            self.conn.close()

    def executar_consulta(self, query, params=None):
        """Executa uma consulta e retorna os resultados formatados"""
        try:
            if params:
                self.cursor.execute(query, params)
            else:
                self.cursor.execute(query)

            colunas = [description[0] for description in self.cursor.description]
            resultados = self.cursor.fetchall()

            return tabulate(resultados, headers=colunas, tablefmt="grid")
        except sqlite3.Error as e:
            return f"Erro na consulta: {e}"

    def listar_livros_com_autores(self):
        """Lista todos os livros com seus respectivos autores"""
        query = """
        SELECT l.titulo as "Título", 
               a.nome as "Autor", 
               l.ano_publicacao as "Ano",
               l.quantidade_copias as "Quantidade"
        FROM Livros l
        JOIN Autores a ON l.autor_id = a.autor_id
        """
        return self.executar_consulta(query)

    def verificar_emprestimos_ativos(self):
        """Verifica todos os empréstimos ativos"""
        query = """
        SELECT u.nome as "Usuário",
               l.titulo as "Livro",
               e.data_emprestimo as "Data Empréstimo",
               e.data_devolucao_prevista as "Devolução Prevista",
               CASE 
                   WHEN date('now') > e.data_devolucao_prevista THEN 'ATRASADO'
                   ELSE 'NORMAL'
               END as "Status"
        FROM Emprestimos e
        JOIN Usuarios u ON e.usuario_id = u.usuario_id
        JOIN Livros l ON e.livro_id = l.livro_id
        WHERE e.data_devolucao_real IS NULL
        """
        return self.executar_consulta(query)

    def buscar_livro(self, termo_busca):
        """Busca livros por termo de pesquisa"""
        query = """
        SELECT l.titulo as "Título",
               a.nome as "Autor",
               l.ano_publicacao as "Ano",
               l.quantidade_copias as "Quantidade"
        FROM Livros l
        JOIN Autores a ON l.autor_id = a.autor_id
        WHERE l.titulo LIKE ?
        """
        return self.executar_consulta(query, (f"%{termo_busca}%",))

    def estatisticas_biblioteca(self):
        """Mostra estatísticas gerais da biblioteca"""
        queries = {
            "Total de Livros por Autor": """
                SELECT a.nome as "Autor", COUNT(*) as "Total de Livros"
                FROM Autores a
                LEFT JOIN Livros l ON a.autor_id = l.autor_id
                GROUP BY a.autor_id, a.nome
            """,
            "Status dos Empréstimos": """
                SELECT 
                    CASE 
                        WHEN e.data_devolucao_real IS NULL AND date('now') > e.data_devolucao_prevista THEN 'ATRASADO'
                        WHEN e.data_devolucao_real IS NULL THEN 'EMPRESTADO'
                        ELSE 'DEVOLVIDO'
                    END as "Status",
                    COUNT(*) as "Quantidade"
                FROM Emprestimos e
                GROUP BY 
                    CASE 
                        WHEN e.data_devolucao_real IS NULL AND date('now') > e.data_devolucao_prevista THEN 'ATRASADO'
                        WHEN e.data_devolucao_real IS NULL THEN 'EMPRESTADO'
                        ELSE 'DEVOLVIDO'
                    END
            """,
        }

        resultados = {}
        for titulo, query in queries.items():
            resultados[titulo] = self.executar_consulta(query)
        return resultados


def main():
    # Inicializa a conexão com o banco de dados
    db = BibliotecaDB("biblioteca.db")
    db.conectar()

    while True:
        print("\n=== Sistema de Biblioteca ===")
        print("1. Listar todos os livros")
        print("2. Verificar empréstimos ativos")
        print("3. Buscar livro")
        print("4. Ver estatísticas")
        print("5. Sair")

        opcao = input("\nEscolha uma opção: ")

        if opcao == "1":
            print("\nLista de Livros:")
            print(db.listar_livros_com_autores())

        elif opcao == "2":
            print("\nEmpréstimos Ativos:")
            print(db.verificar_emprestimos_ativos())

        elif opcao == "3":
            termo = input("\nDigite o termo de busca: ")
            print(db.buscar_livro(termo))

        elif opcao == "4":
            print("\nEstatísticas da Biblioteca:")
            estatisticas = db.estatisticas_biblioteca()
            for titulo, resultado in estatisticas.items():
                print(f"\n{titulo}:")
                print(resultado)

        elif opcao == "5":
            print("\nEncerrando o programa...")
            break

        else:
            print("\nOpção inválida!")

        input("\nPressione Enter para continuar...")

    # Fecha a conexão ao sair
    db.desconectar()


if __name__ == "__main__":
    main()
