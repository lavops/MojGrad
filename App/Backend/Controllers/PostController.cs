using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.Models.ViewsModel;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PostController : ControllerBase
    {
        private readonly IPostUI _iPostUI;

        public PostController(IPostUI iPostUI)
        {
            _iPostUI = iPostUI;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<IEnumerable<PostViewModel>> GetPosts()
        {
            var posts = _iPostUI.getAllPosts();
            List<PostViewModel> listPosts = new List<PostViewModel>();
            foreach (var post in posts)
            {
                listPosts.Add(new PostViewModel(post));
            }

            return listPosts;
        }

        [Authorize]
        [HttpPost("UsersPosts")]
        public ActionResult<IEnumerable<PostViewModel>> UsersPosts(User user)
        {
            var posts = _iPostUI.getAllPostsForOneUser(user.id);
            List<PostViewModel> listPosts = new List<PostViewModel>();
            foreach (var post in posts)
            {
                listPosts.Add(new PostViewModel(post));
            }

            return listPosts;
        }

        [Authorize]
        [HttpGet("SolvedPosts")]
        public ActionResult<IEnumerable<PostViewModel>> SolvedPosts()
        {
            var posts = _iPostUI.getAllSolvedPosts();
            List<PostViewModel> listPosts = new List<PostViewModel>();
            foreach (var post in posts)
            {
                listPosts.Add(new PostViewModel(post));
            }

            return listPosts;
        }

        [Authorize]
        [HttpGet("UnsolvedPosts")]
        public ActionResult<IEnumerable<PostViewModel>> UnsolvedPosts()
        {
            var posts = _iPostUI.getAllUnsolvedPosts();
            List<PostViewModel> listPosts = new List<PostViewModel>();
            foreach (var post in posts)
            {
                listPosts.Add(new PostViewModel(post));
            }

            return listPosts;
        }

        [Authorize]
        [HttpPost]
        public IActionResult InsertPost(Post post)
        {
            Post p = _iPostUI.insertPost(post);
            if (p != null)
                return Ok(p);
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

        [Authorize]
        [HttpPost("editPost")]
        public IActionResult EditPost(Post post)
        {
            Post p = _iPostUI.editPost(post);
            if (p != null)
            {
                PostViewModel post1 = new PostViewModel(p);
                return Ok(post1);
            }
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

        [Authorize]
        [HttpPost("Delete")]
        public IActionResult DeletePost(Post post)
        {
            bool ind = _iPostUI.deletePost(post.id);
            if (ind == true)
            {
                return Ok(new { message = "Obrisan" });
            }
            else
                return BadRequest(new { message = "Greska" });
        }

    }
}