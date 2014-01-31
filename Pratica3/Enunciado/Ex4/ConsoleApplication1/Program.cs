using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{

    class Aluno
    {
        public int Numero { get; set; }
        public string Nome { get; set; }
        public float Altura { get; set; }
        public int Idade { get; set; }
        public List<Disciplina> Disciplinas { get; set; }

    }
    class Disciplina
    {
        public int Cod { get; set; }
        public string Des { get; set; }
    }

    class Program
    {
        static void Main(string[] args)
        {

            List<Aluno> alunos =
             new List<Aluno>{
               new Aluno{Numero=1111,Nome="Ze",Altura=1.8F,Idade=23,
                                    Disciplinas=new List<Disciplina>{ new Disciplina{Cod=1,Des="ASI"},
                                                                            new Disciplina{Cod=2,Des="IESD"}
                                    }},
                new Aluno{Numero=2222,Nome="Ana",Altura=1.7F,Idade = 22,
                                          Disciplinas=new List<Disciplina>{ new Disciplina{Cod=1,Des="ASI"}
                                    }},
                new Aluno{Numero=3333,Nome="Pedro",Altura=1.7F,Idade = 24,
                                     Disciplinas=new List<Disciplina>{ new Disciplina{Cod=1,Des="ASI"}
                                     }},
                new Aluno{Numero=4444,Nome="Rita",Altura=1.7F, Idade = 22,
                                    Disciplinas=new List<Disciplina>{ new Disciplina{Cod=1,Des="ASI"},
                                                                            new Disciplina{Cod=3,Des="ES"}
                                    }}
            };
            var Nomes = new List<String> { "Ze", "Luis", "Rita", "Ze" };


            // Assim dá erro (tipo anónimo não tem definição de Distinct)
            //var q14 = from a in alunos
            //          from d in a.Disciplinas
            //          select new { d.Cod, d.Des }
            //       .Distinct();

            var q14 = (from a in alunos
                       from d in a.Disciplinas
                       select new { d.Cod, d.Des })
                    .Distinct();
            foreach (var d in q14)
            {
                Console.WriteLine(d.Cod + " " + d.Des);
            }



            //var q1_1 = from a in alunos
            //           from a1 in alunos
            //           select new { n1 = a.Numero, n2 = a1.Numero };


            //foreach (var aa in q1_1)
            //    Console.WriteLine(aa.n1 + "," + aa.n2);

            //var q2_1 = from a in alunos
            //         from d in a.Disciplinas
            //         select d.Des;

            //Console.WriteLine("Disciplinas do aluno " + 1111);
            //foreach (var d in q2_1)
            //    Console.WriteLine(d);


            //var q1_2 = from a in alunos
            //           from d in a.Disciplinas
            //           select new { num = a.Numero, d = d.Des };


            //foreach (var par in q1_2)
            //    Console.WriteLine(par.num + "," + par.d);

            //var q1_2_2 = alunos
            //             .SelectMany(a => a.Disciplinas, (a, d) => new { num = a.Numero, d = d.Des });
            //foreach (var par in q1_2_2)
            //    Console.WriteLine(par.num + "," + par.d);



            //var q4 = alunos
            //     //.Where(a => a.Numero == 1111)
            //     .SelectMany(a => a.Disciplinas)
            //     .Select(d => d.Des);

            //Console.WriteLine("Disciplinas do aluno " + 1111);
            //foreach (var d in q4)
            //    Console.WriteLine(d);

            //var q1_2_1 = alunos
            //             .SelectMany(a=>a.Disciplinas,(a,d) => new{num = a.Numero, d=d.Des});

            //var q5 = alunos
            //       .SelectMany(a => alunos, (a, a1) => new { n1 = a.Numero, n2=a1.Numero });
            //       //.Select(par => new
            //       //{
            //       //    n1 = par.a.Numero,
            //       //    n2 = par.a1.Numero
            //       //});

            //Console.WriteLine("a do aluno " + 1111);
            //foreach (var par in q5)
            //    Console.WriteLine(par.n1+ ","+ par.n2);



            //var q8_1 = alunos
            //         .Join(Nomes, a => a.Nome, n => n, (x, y) => new { a = x, n = y })
            //         .Select(p => p.a.Nome);

            //foreach (var a in q8_1)
            //    Console.WriteLine(a);

            //var q8_1_1 = alunos
            //      .Join(Nomes, a => a.Nome, n => n, (x, y) => x.Nome);


            //foreach (var a in q8_1_1)
            //    Console.WriteLine(a);

        }
    }
}
