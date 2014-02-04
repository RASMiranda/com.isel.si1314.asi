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
    public class EncomendaController : Controller
    {
        private ASIVesteContext db = new ASIVesteContext();

        //
        // GET: /Encomenda/

        public ActionResult Index()
        {
            return View(db.Encomendas.Include(p => p.Produto).OrderBy( p=> p.EncomendaID).ToList());
        }

        // dá entrada de uma encomenda pendente
        // GET: /Encomenda/Entrada


        public ActionResult Entrada(int id = 0)
        {
            Encomenda encomenda = db.Encomendas.Find(id); 

            if (encomenda == null)
            {
                return HttpNotFound();
            }
            else
            {
                encomenda.Estado = EstadoEncomenda.Recebida;
                db.Entry(encomenda).State = EntityState.Modified;
                db.SaveChanges();

            }
            return RedirectToAction("Index");
        }




        //s
        // GET: /Encomenda/Details/5

        public ActionResult Details(int id = 0)
        {
            Encomenda encomenda = db.Encomendas.Find(id);
            if (encomenda == null)
            {
                return HttpNotFound();
            }
            return View(encomenda);
        }

        //
        // GET: /Encomenda/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /Encomenda/Create

        [HttpPost]
        public ActionResult Create(Encomenda encomenda)
        {
            if (ModelState.IsValid)
            {
                db.Encomendas.Add(encomenda);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(encomenda);
        }

        //
        // GET: /Encomenda/Edit/5

        public ActionResult Edit(int id = 0)
        {
            Encomenda encomenda = db.Encomendas.Find(id);
            if (encomenda == null)
            {
                return HttpNotFound();
            }
            return View(encomenda);
        }

        //
        // POST: /Encomenda/Edit/5

        [HttpPost]
        public ActionResult Edit(Encomenda encomenda)
        {
            if (ModelState.IsValid)
            {
                db.Entry(encomenda).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(encomenda);
        }

        //
        // GET: /Encomenda/Delete/5

        public ActionResult Delete(int id = 0)
        {
            Encomenda encomenda = db.Encomendas.Find(id);
            if (encomenda == null)
            {
                return HttpNotFound();
            }
            return View(encomenda);
        }

        //
        // POST: /Encomenda/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            Encomenda encomenda = db.Encomendas.Find(id);
            db.Encomendas.Remove(encomenda);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}