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
    public class DAOAlunoInteresse: IDAOAlunoInteresse
    {
        private ISessionAlunos MySession;
        private SqlCommand CreateCommand()
        {
            return MySession.CreateCommand();
        }

        
        public DAOAlunoInteresse(ISessionAlunos s)
        {

            MySession = s;
            
        }

        public void Create(AlunoInteresse ai)
        {
           using (var das = MySession.CreateDataAccessScope(true))
            {
                SqlCommand cmd = CreateCommand();

                cmd.CommandText = "INSERT INTO ALUNOSASSEST(NumAl,Interesse) VALUES(@NumAl,@Interesse)";
                SqlParameter p1 = cmd.CreateParameter();
                SqlParameter p2 = cmd.CreateParameter();
                cmd.Parameters.Add(p1);
                cmd.Parameters.Add(p2);

                p1.ParameterName = "@NumAl";
                p1.SqlDbType = SqlDbType.Int;
                p2.ParameterName = "@Interesse";
                p2.SqlDbType = SqlDbType.VarChar;
                p2.Size = 20;

                p1.Value = ai.Numero;
                p2.Value = ai.Interesse;
                

                cmd.ExecuteNonQuery();

                das.Commit();
            }
        }

        public AlunoInteresse Read(AlunoInteresseKey id)
        {


            throw new NotImplementedException("Oparação CRUD Ainda não implementada");

        }

        public void Update(AlunoInteresse ai)
        {
            throw new NotImplementedException("Oparação CRUD Ainda não implementada");
        }

        public void Delete(AlunoInteresse ai)
        {
            throw new NotImplementedException("Oparação CRUD Ainda não implementada");
        }

    
    }
}
