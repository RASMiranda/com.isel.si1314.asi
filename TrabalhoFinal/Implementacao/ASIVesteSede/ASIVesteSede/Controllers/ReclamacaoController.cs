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
    public class ReclamacaoController : Controller
    {
        private ASIVesteContext db = new ASIVesteContext();

        //
        // GET: /Reclamacao/

        public ActionResult Index()
        {
            return View(db.Reclamacaos.ToList());
        }

        //
        // GET: /Reclamacao/Details/5

        public ActionResult Details(int id = 0)
        {
            Reclamacao reclamacao = db.Reclamacaos.Find(id);
            if (reclamacao == null)
            {
                return HttpNotFound();
            }
            return View(reclamacao);
        }

        //
        // GET: /Reclamacao/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /Reclamacao/Create

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Reclamacao reclamacao)
        {
            if (ModelState.IsValid)
            {
                db.Reclamacaos.Add(reclamacao);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(reclamacao);
        }

        //
        // GET: /Reclamacao/Edit/5

        public ActionResult Edit(int id = 0)
        {
            Reclamacao reclamacao = db.Reclamacaos.Find(id);
            if (reclamacao == null)
            {
                return HttpNotFound();
            }
            return View(reclamacao);
        }

        //
        // POST: /Reclamacao/Edit/5

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Reclamacao reclamacao)
        {
            if (ModelState.IsValid)
            {
                db.Entry(reclamacao).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(reclamacao);
        }

        //
        // GET: /Reclamacao/Delete/5

        public ActionResult Delete(int id = 0)
        {
            Reclamacao reclamacao = db.Reclamacaos.Find(id);
            if (reclamacao == null)
            {
                return HttpNotFound();
            }
            return View(reclamacao);
        }

        //
        // POST: /Reclamacao/Delete/5

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Reclamacao reclamacao = db.Reclamacaos.Find(id);
            db.Reclamacaos.Remove(reclamacao);
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