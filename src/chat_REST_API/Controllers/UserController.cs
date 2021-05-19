using API.Helpers;
using chat_SignalR.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using SignalR_chat_API.Data;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace chat_SignalR.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : Controller
    {
        private databaseContext context = new databaseContext();
        /*
        [HttpGet("ProbaUsers")]
        public IActionResult Proba()
        {
            return Ok("Radi");
        }

        [HttpGet("CountUsers")]
        public int CountUsers()
        {
            int broj = context.Users.Count();
            return broj;
        }
        */
        [HttpGet("GetUser")]
        public User GetUser(int id)
        {
            return context.Users.Where(x => x.Id == id).FirstOrDefault();
        }

        [HttpGet("GetUsers")]
        public List<User> GetUsers()
        {
            var user = context.Users.Select(u => new User { Id = u.Id, metaMaskAddress = u.metaMaskAddress , privateKey=u.privateKey, First_Name = u.First_Name, Last_Name = u.Last_Name }).ToList();
            if (user == null)
            {
                return null;
            }
            else
            {
                return user;
            }
        }

        [HttpPost("AddUser")]
        public IActionResult AddUser([FromBody] User userParam)
        {
            var isUserPresent = context.Users.Where(u => u.Id == userParam.Id || u.metaMaskAddress == userParam.metaMaskAddress);
            if (!isUserPresent.Any())
            {
                User user = new User();
                user.Id = userParam.Id;
                user.metaMaskAddress = userParam.metaMaskAddress;
                user.privateKey = userParam.privateKey;
                user.First_Name = userParam.First_Name;
                user.Last_Name = userParam.Last_Name;

                context.Users.Add(user);
                context.SaveChanges();

                return Ok(user);
            }
            else
            {
                return BadRequest(new { message = "User already exists!" });
            }
        }

        [HttpDelete("DeleteUser")]
        public IActionResult Delete(int id)
        {
            var user = context.Users.Where(x => x.Id == id).FirstOrDefault();
            if (user == null)
            {
                return BadRequest(new { message = "ID of user not present!" });
            }
            else
            {
                context.Users.Remove(user);
                context.SaveChanges();
                return Ok("Deleted user from " + user+ "successfully");
            }
        }

    }
}
