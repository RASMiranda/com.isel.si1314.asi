using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ASIVesteSede.Models;
using ASIVesteSede.DAL;

namespace ASIVesteSede.Controllers
{
    public class ProdutoController : Controller
    {
        private ASIVesteContext db = new ASIVesteContext();

        //
        // GET: /Produto/

        public ActionResult Index()
        {
            var produtos = db.Produtos.Include(p => p.Fornecedor);
            return View( produtos.ToList());
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