using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.Models.ViewsModel;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserUI _iUserUI;

        public UserController(IUserUI iUserUI)
        {
            _iUserUI = iUserUI;
        }


        [HttpGet]
        public IEnumerable<UserViewModel> GetUsers()
        {
            var users = _iUserUI.getAllUsers();
            List<UserViewModel> user = new List<UserViewModel>();
            foreach (var u in users)
            {
                user.Add(new UserViewModel(u));
            }

            return user;

        }

        [HttpGet("{id}")]
        public UserViewModel GetUser(long id)
        {
            var user = _iUserUI.getByID(id);
            UserViewModel userr = new UserViewModel(user);
            return userr;

        }

        [HttpPost("Login")]
        public IActionResult Login([FromBody] User userParam)
        {
            User user = _iUserUI.login(userParam);
            if (user != null)
                return Ok(user);
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }

        [HttpPost("Register")]
        public IActionResult Register(User u)
        {
            User user = _iUserUI.insertUser(u);
            if (user != null)
                return Ok(user);
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }


        }
}