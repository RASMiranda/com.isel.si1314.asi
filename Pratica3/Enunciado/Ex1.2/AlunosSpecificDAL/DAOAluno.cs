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


using System.Configuration;
using System.Transactions;

using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;


using Ex3.AlunosInterfaces;
using Ex3.Entidades;



namespace Ex3.SpecificDAL

{
    public class DAOAluno: IDAOAluno
    {
        private string cs;


        public DAOAluno()
        {
            cs = ConfigurationManager.ConnectionStrings["base dados"].ConnectionString;
        }


        public void Create(Aluno a)
        {
           using (var ts = new TransactionScope(TransactionScopeOption.Required) )
            {
               
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "INSERT INTO ALUNOS (NumAl,Nome) VALUES(@NumAl,@Nome)";
                SqlParameter p1 = new SqlParameter("@NumAl", a.Numero);
                SqlParameter p2 = new SqlParameter("@Nome", a.Nome);
                cmd.Parameters.Add(p1);
                cmd.Parameters.Add(p2);

                using (var cn = new SqlConnection(cs))
                {
                   
                    cmd.Connection = cn;
                    cn.Open();
                  
                    cmd.ExecuteNonQuery();

                    if (a.Interesses != null)
                    {

                        var daoI = new DAOAlunoInteresse();

                        foreach (var interesse in a.Interesses)
                        {

                            daoI.Create(interesse);
                        }
                    }

                }
                ts.Complete();
            }
        }

        public Aluno Read(int id)
        {
            
            return null;

        }

        public void Update(Aluno a)
        {
        }
        public void Delete(Aluno a)
        {
        }

    }
}
