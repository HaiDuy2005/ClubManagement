using System;
using System.Linq;
using System.Threading.Tasks;
using ClubManagement.Models;
using ClubManagement.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ClubManagement.Controllers
{
    public class ClubActivitiesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ClubActivitiesController(ApplicationDbContext context)
        {
            _context = context;
        }


        public async Task<IActionResult> Index(
            string? searchName,
            string? searchLocation,
            DateTime? searchDate)
        {
            var query = _context.Activities
                .AsNoTracking()
                .AsQueryable();


            if (!string.IsNullOrWhiteSpace(searchName))
            {
                query = query.Where(a =>
                    a.ActivityName.Contains(searchName));
            }


            if (!string.IsNullOrWhiteSpace(searchLocation))
            {
                query = query.Where(a =>
                    a.Location.Contains(searchLocation));
            }


            if (searchDate.HasValue)
            {
                var date = searchDate.Value.Date;
                var nextDate = date.AddDays(1);

                query = query.Where(a =>
                    a.ActivityDate >= date &&
                    a.ActivityDate < nextDate);
            }

            var activities = await query
                .OrderByDescending(a => a.ActivityDate)
                .ThenByDescending(a => a.ActivityId)
                .ToListAsync();


            ViewBag.SearchName = searchName;
            ViewBag.SearchLocation = searchLocation;
            ViewBag.SearchDate = searchDate?.ToString("yyyy-MM-dd");

            return View(activities);
        }


        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var activity = await _context.Activities
                .FirstOrDefaultAsync(a => a.ActivityId == id);

            if (activity == null)
                return NotFound();

            return View(activity);
        }


        public IActionResult Create()
        {
            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(
            [Bind("ActivityId,ActivityName,Description,Location,ActivityDate,ClubId")]
            ClubActivity clubactivity)
        {
            if (ModelState.IsValid)
            {
                _context.Add(clubactivity);
                await _context.SaveChangesAsync();

                return RedirectToAction(nameof(Index));
            }

            return View(clubactivity);
        }

        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var activity = await _context.Activities.FindAsync(id);

            if (activity == null)
                return NotFound();

            return View(activity);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(
            int id,
            [Bind("ActivityId,ActivityName,Description,Location,ActivityDate,ClubId")]
            ClubActivity clubactivity)
        {
            if (id != clubactivity.ActivityId)
                return NotFound();

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(clubactivity);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ClubActivityExists(clubactivity.ActivityId))
                        return NotFound();

                    throw;
                }

                return RedirectToAction(nameof(Index));
            }

            return View(clubactivity);
        }


        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var activity = await _context.Activities
                .FirstOrDefaultAsync(a => a.ActivityId == id);

            if (activity == null)
                return NotFound();

            return View(activity);
        }

     
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var activity = await _context.Activities.FindAsync(id);

            if (activity != null)
            {
                _context.Activities.Remove(activity);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Index));
        }

        private bool ClubActivityExists(int id)
        {
            return _context.Activities.Any(a =>
                a.ActivityId == id);
        }

  
        public async Task<IActionResult> Participants(int id)
        {
            var list = await _context.ActivityRegistrations
                .AsNoTracking()
                .Where(x => x.ActivityId == id && x.IsApproved == true)
                .ToListAsync();

            return View(list);
        }
    }
}