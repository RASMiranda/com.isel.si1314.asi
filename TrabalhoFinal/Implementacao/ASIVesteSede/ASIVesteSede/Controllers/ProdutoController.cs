using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ASIVesteSede.Models;
using ASIVesteSede.DAL;

using PagedList;
using System.Configuration;

namespace ASIVesteSede.Controllers
{
    public class ProdutoController : Controller
    {
        private ASIVesteContext db = new ASIVesteContext();

        //
        // GET: /Produto/

        //public ActionResult Index()
        //{
        //    var produtos = db.Produtos.Include(p => p.Fornecedor);
        //    return View( produtos.ToList());
        //}

        public ViewResult Index(string sortOrder, string currentFilter, string searchString, int? page)
        {
            //TODO?: Try Catch->Pretty message?
            //TODO?: Permitir sorting dentro do filtro?
            //TODO?: Filtro numerico de intervalos Preco/StockQtd?

            ViewBag.CurrentSort = sortOrder;
            ViewBag.CodigoSortParm = String.IsNullOrEmpty(sortOrder) ? "Codigo_desc" : "";
            ViewBag.DesignacaoSortParm = sortOrder == "Designacao" ? "Designacao_desc" : "Designacao";
            ViewBag.TipoSortParm = sortOrder == "Tipo" ? "Tipo_desc" : "Tipo";
            ViewBag.FornecedorSortParm = sortOrder == "Fornecedor" ? "Fornecedor_desc" : "Fornecedor";
            ViewBag.StockQtdSortParm = sortOrder == "StockQtd" ? "StockQtd_desc" : "StockQtd";
            ViewBag.StockMinimoSortParm = sortOrder == "StockMinimo" ? "StockMinimo_desc" : "StockMinimo";
            ViewBag.PrecoSortParm = sortOrder == "Preco" ? "Preco_desc" : "Preco";


            if (searchString != null)
            {
                page = 1;
            }
            else
            {
                searchString = currentFilter;
            }

            ViewBag.CurrentFilter = searchString;

            var produtos = db.Produtos.Include(p => p.Fornecedor);
            if (!String.IsNullOrEmpty(searchString))
            {
                TipoProduto tipo;
                if (Enum.TryParse(searchString, out tipo))
                {
                    produtos = produtos.Where(s => s.Codigo.ToUpper().Contains(searchString.ToUpper())
                                           || s.Designacao.ToUpper().Contains(searchString.ToUpper())
                                           || s.Tipo == tipo
                                           || s.Fornecedor.Nome.ToUpper().Contains(searchString.ToUpper()));

                }
                else
                {
                    produtos = produtos.Where(s => s.Codigo.ToUpper().Contains(searchString.ToUpper())
                                           || s.Designacao.ToUpper().Contains(searchString.ToUpper())
                                           || s.Fornecedor.Nome.ToUpper().Contains(searchString.ToUpper()));
                }
            }
            switch (sortOrder)
            {
                case "Codigo_desc":
                    produtos = produtos.OrderByDescending(s => s.Codigo);
                    break;
                case "Designacao":
                    produtos = produtos.OrderBy(s => s.Designacao);
                    break;
                case "Designacao_desc":
                    produtos = produtos.OrderByDescending(s => s.Designacao);
                    break;
                case "Tipo":
                    produtos = produtos.OrderBy(s => s.Tipo);
                    break;
                case "Tipo_desc":
                    produtos = produtos.OrderByDescending(s => s.Tipo);
                    break;
                case "Fornecedor":
                    produtos = produtos.OrderBy(s => s.Fornecedor.Nome);
                    break;
                case "Fornecedor_desc":
                    produtos = produtos.OrderByDescending(s => s.Fornecedor.Nome);
                    break;
                case "StockMinimo":
                    produtos = produtos.OrderBy(s => s.StockMinimo);
                    break;
                case "StockMinimo_desc":
                    produtos = produtos.OrderByDescending(s => s.StockMinimo);
                    break;
                case "StockQtd":
                    produtos = produtos.OrderBy(s => s.StockQtd);
                    break;
                case "StockQtd_desc":
                    produtos = produtos.OrderByDescending(s => s.StockQtd);
                    break;
                case "Preco":
                    produtos = produtos.OrderBy(s => s.Preco);
                    break;
                case "Preco_desc":
                    produtos = produtos.OrderByDescending(s => s.Preco);
                    break;
                default:
                    produtos = produtos.OrderBy(s => s.Codigo);
                    break;
            }
            int pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["pageSize"]);
            int pageNumber = (page ?? 1);
            return View(produtos.ToPagedList(pageNumber, pageSize));
        }

        // GET: /ProdutoStock/

        public ActionResult Stock()
        {
            var produtos = db.Produtos.Include(p => p.Fornecedor).OrderBy( p => p.Codigo );
            return View(produtos.ToList());
        }

        //
        // GET: /Produto/Details/5

        public ActionResult Details(int id = 0)
        {
            Produto produto = db.Produtos.Find(id);
            if (produto == null)
            {
                return HttpNotFound();
            }
            return View(produto);
        }

        //
        // GET: /Produto/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /Produto/Create

        [HttpPost]
        public ActionResult Create(Produto produto)
        {
            int tipoProd = -1;

            switch(produto.Tipo)
            {
                case TipoProduto.Senhora:  tipoProd = 0; break;
                case TipoProduto.Crianca:  tipoProd = 1; break;
                case TipoProduto.Homem:  tipoProd = 2; break;
                case TipoProduto.Desportista:  tipoProd = 3; break;
            };

            if (ModelState.IsValid)
            {
                db.sp_inserirProduto(
                    tipoProd,               produto.Codigo,
                    produto.Designacao,     produto.StockQtd,
                    produto.StockMinimo,    produto.Preco,
                    produto.Fornecedor.FornecedorID
                );

                db.Produtos.Add(produto);
                db.Entry<Produto>(produto).State = EntityState.Unchanged;
                //db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(produto);
        }

        //
        // GET: /Produto/Edit/5

        public ActionResult Edit(int id = 0)
        {
            Produto produto = db.Produtos.Find(id);
            if (produto == null)
            {
                return HttpNotFound();
            }
            return View(produto);
        }

        //
        // POST: /Produto/Edit/5

        [HttpPost]
        public ActionResult Edit(Produto produto)
        {
            int tipoProd = -1;

            switch (produto.Tipo)
            {
                case TipoProduto.Senhora: tipoProd = 0; break;
                case TipoProduto.Crianca: tipoProd = 1; break;
                case TipoProduto.Homem: tipoProd = 2; break;
                case TipoProduto.Desportista: tipoProd = 3; break;
            };

            string codigoOriginal = db.Entry<Produto>(produto).OriginalValues.GetValue<string>("Codigo");

            if (ModelState.IsValid)
            {
                db.sp_actualizarProduto(
                    produto.ProdutoID, tipoProd, 
                    codigoOriginal,
                    produto.Designacao, produto.StockQtd,
                    produto.StockMinimo, produto.Preco,
                    produto.Fornecedor.FornecedorID,
                    produto.Codigo // se null o SP usa o codigoOriginal
                );

                db.Produtos.Add(produto);
                db.Entry<Produto>(produto).State = EntityState.Unchanged;
                //db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(produto);
        }

        //
        // GET: /Produto/Delete/5

        public ActionResult Delete(int id = 0)
        {
            Produto produto = db.Produtos.Find(id);
            if (produto == null)
            {
                return HttpNotFound();
            }
            return View(produto);
        }

        //
        // POST: /Produto/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            Produto produto = db.Produtos.Find(id);
            db.sp_removerProduto( produto.ProdutoID, produto.Codigo );
            db.Produtos.Remove(produto);
            //db.SaveChanges();
            db.Entry<Produto>(produto).State = EntityState.Deleted;

            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}