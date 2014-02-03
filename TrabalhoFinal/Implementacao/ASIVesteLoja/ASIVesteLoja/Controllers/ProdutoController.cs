using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ASIVesteLoja.Models;
using ASIVesteLoja.DAL;

namespace ASIVesteLoja.Controllers
{
    public class ProdutoController : Controller
    {
        private ASIVesteContext db = new ASIVesteContext();

        //
        // GET: /Produto/

        public ActionResult Index(string sortOrder)
        {
            ViewBag.CodigoSortParm = String.IsNullOrEmpty(sortOrder) ? "Codigo_desc" : "";
            ViewBag.DesignacaoSortParm = sortOrder == "Designacao" ? "Designacao_desc" : "Designacao";
            ViewBag.StockQtdSortParm = sortOrder == "StockQtd" ? "StockQtd_desc" : "StockQtd";
            ViewBag.PrecoSortParm = sortOrder == "Preco" ? "Preco_desc" : "Preco";
            var produtos = from s in db.Produtos
                           select s;
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

        //public ActionResult Create()
        //{
        //    return View();
        //}

        //
        // POST: /Produto/Create

        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public ActionResult Create(Produto produto)
        //{
        //    if (ModelState.IsValid)
        //    {
        //        db.Produtos.Add(produto);
        //        db.SaveChanges();
        //        return RedirectToAction("Index");
        //    }

        //    return View(produto);
        //}

        ////
        //// GET: /Produto/Edit/5

        //public ActionResult Edit(int id = 0)
        //{
        //    Produto produto = db.Produtos.Find(id);
        //    if (produto == null)
        //    {
        //        return HttpNotFound();
        //    }
        //    return View(produto);
        //}

        //
        // POST: /Produto/Edit/5

        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public ActionResult Edit(Produto produto)
        //{
        //    if (ModelState.IsValid)
        //    {
        //        db.Entry(produto).State = EntityState.Modified;
        //        db.SaveChanges();
        //        return RedirectToAction("Index");
        //    }
        //    return View(produto);
        //}

        //
        // GET: /Produto/Delete/5

        //public ActionResult Delete(int id = 0)
        //{
        //    Produto produto = db.Produtos.Find(id);
        //    if (produto == null)
        //    {
        //        return HttpNotFound();
        //    }
        //    return View(produto);
        //}

        //
        // POST: /Produto/Delete/5

        //[HttpPost, ActionName("Delete")]
        //[ValidateAntiForgeryToken]
        //public ActionResult DeleteConfirmed(int id)
        //{
        //    Produto produto = db.Produtos.Find(id);
        //    db.Produtos.Remove(produto);
        //    db.SaveChanges();
        //    return RedirectToAction("Index");
        //}

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}