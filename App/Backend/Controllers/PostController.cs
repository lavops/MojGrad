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
        [HttpGet("userId={userId}")]
        public ActionResult<IEnumerable<PostViewModel>> GetPosts(int userId)
        {
            var posts = _iPostUI.getAllPosts();
            List<PostViewModel> listPosts = new List<PostViewModel>();
            foreach (var post in posts)
            {
                listPosts.Add(new PostViewModel(post,userId));
            }

            return listPosts;
        }

        [Authorize]
        [HttpGet("ByCityId/userId={userId}/cityId={cityId}")]
        public ActionResult<IEnumerable<PostViewModel>> GetPostsByCityId(int userId, int cityId)
        {
            var posts = _iPostUI.getAllPostsByCityId(cityId);
            List<PostViewModel> listPosts = new List<PostViewModel>();
            foreach (var post in posts)
            {
                listPosts.Add(new PostViewModel(post, userId));
            }

            return listPosts;
        }

        public class SubPost
        {
            public long id { get; set; }
            public long userID { get; set; }
            public string description { get; set; }
        }
       
        [Authorize]
        [HttpPost("UsersPosts")]
        public ActionResult<IEnumerable<PostViewModel>> UsersPosts(SubPost user)
        {
            var posts = _iPostUI.getAllPostsForOneUser(user.id);
            List<PostViewModel> listPosts = new List<PostViewModel>();
            foreach (var post in posts)
            {
                listPosts.Add(new PostViewModel(post, user.userID));
            }

            return listPosts;
        }
        
        [Authorize]
        [HttpGet("SolvedPosts/userId={userId}")]
        public ActionResult<IEnumerable<PostViewModel>> SolvedPosts(int userId)
        {
            var posts = _iPostUI.getAllSolvedPosts();
            List<PostViewModel> listPosts = new List<PostViewModel>();
            foreach (var post in posts)
            {
                listPosts.Add(new PostViewModel(post,userId));
            }

            return listPosts;
        }
        [Authorize]
        [HttpGet("SolvedPostsByCityId/userId={userId}/cityId={cityId}")]
        public ActionResult<IEnumerable<PostViewModel>> SolvedPostsByCityId(int userId, int cityId)
        {
            var posts = _iPostUI.getAllSolvedPostsByCityId(cityId);
            List<PostViewModel> listPosts = new List<PostViewModel>();
            foreach (var post in posts)
            {
                listPosts.Add(new PostViewModel(post, userId));
            }

            return listPosts;
        }

        [Authorize]
        [HttpGet("UnsolvedPosts/userId={userID}")]
        public ActionResult<IEnumerable<PostViewModel>> UnsolvedPosts(int userId)
        {
            var posts = _iPostUI.getAllUnsolvedPosts();
            List<PostViewModel> listPosts = new List<PostViewModel>();
            foreach (var post in posts)
            {
                listPosts.Add(new PostViewModel(post,userId));
            }

            return listPosts;
        }
        [Authorize]
        [HttpGet("UnsolvedPostsByCityId/userId={userID}/cityId={cityId}")]
        public ActionResult<IEnumerable<PostViewModel>> UnsolvedPostsByCityId(int userId, int cityId)
        {
            var posts = _iPostUI.getAllUnsolvedPostsByCityId(cityId);
            List<PostViewModel> listPosts = new List<PostViewModel>();
            foreach (var post in posts)
            {
                listPosts.Add(new PostViewModel(post, userId));
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
        public IActionResult EditPost(SubPost pos)
        {
            Post p = _iPostUI.editPost(pos.id, pos.description);
            if (p != null)
            {
                PostViewModel post1 = new PostViewModel(p, pos.userID);
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

        [Authorize]
        [HttpPost("PostsSolvedByInstitution")]
        public ActionResult<IEnumerable<PostViewModel>> PostsSolvedByInstitution(Institution inst)
        {
            var posts = _iPostUI.getAllPostsSolvedByOneInstitution(inst.id);
            List<PostViewModel> listPosts = new List<PostViewModel>();
            foreach (var post in posts)
            {
                listPosts.Add(new PostViewModel(post, 0));
            }

            return listPosts;
        }

    }
}