/*
 * Este código foi desenvolvido para exemplificação e consolidação
 * de coceitos da unidade curricular Arquitectura de Sistemas de Informação do
 * Mestredo em Engenharia Informática e de Computadores do Instituto Superior de Engenharia
 * de Lisboa (Institupo Politécnico de Lisboa)
 * Não é completo, nem é destinado a ser usado como peça de produtos informáticos fora 
 * do âmbito pedagógico.
 * 
 * -------------------------------------
 * Autor: Walter Vieira
 * -------------------------------------
 * Data de criaçao: 2012/11/14
 * -------------------------------------
 * História de alterações:
 * 
 * 2012/11/19 - Walter Vieira. Introduzidos estes comentários.
 * 
 * 
*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Ex2.AlunosInterfaces;
using Ex2.Entidades;
using Ex2.DALAbstraction;


using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;



namespace Ex2.SpecificDAL

{
    public class DAOAluno: IDAOAluno
    {
        private ISessionAlunos MySession;
        private SqlCommand CreateCommand()
        {
            return MySession.CreateCommand();
        }

        
        public DAOAluno(ISessionAlunos s)
        {

            MySession = s;
            
        }

        public void Create(Aluno a)
        {
           using (var das = MySession.CreateDataAccessScope(true))
            {
                
                SqlCommand cmd = CreateCommand();
                cmd.CommandText = "INSERT INTO ALUNOS (NumAl,Nome) VALUES(@NumAl,@Nome)";
                SqlParameter p1 = new SqlParameter("@NumAl", a.Numero);
                SqlParameter p2 = new SqlParameter("@NOme", a.Nome);
                cmd.Parameters.Add(p1);
                cmd.Parameters.Add(p2);

                cmd.ExecuteNonQuery();

                if (a.Interesses != null)
                {
                                       
                    var daoI = new DAOAlunoInteresse(MySession);

                    foreach (var interesse in a.Interesses)
                    {

                        daoI.Create(interesse);
                    }
                }
                das.Commit();
            }
        }

        public Aluno Read(int id)
        {
            throw new NotImplementedException("Operação CRUD ainda não implementada");

        }

        public void Update(Aluno a)
        {
            throw new NotImplementedException("Operação CRUD ainda não implementada");
        }
        public void Delete(Aluno a)
        {
            throw new NotImplementedException("Operação CRUD ainda não implementada");
        }

 
    }
}
