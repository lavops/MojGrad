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
    public class LikeController : ControllerBase
    {
        private readonly ILikeUI _iLikeUI;

        public LikeController(ILikeUI iLikeUI)
        {
            _iLikeUI = iLikeUI;
        }

        [HttpPost]
        public IActionResult InsertLike(Like l)
        {
            Like like = _iLikeUI.insertLike(l);
            if (like != null)
                return Ok(like);
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

        [HttpPost("DislikeInPost")]
        public IEnumerable<LikeViewModel> DislikeInPost([FromBody] Post postParam)
        {
            var dislikes = _iLikeUI.getDislikeInPost(postParam.id);
            List<LikeViewModel> likes = new List<LikeViewModel>();
            foreach (var d in dislikes)
            {
                likes.Add(new LikeViewModel(d));
            }

            return likes;
        }

        [HttpPost("LikeInPost")]
        public IEnumerable<LikeViewModel> LikeInPost([FromBody] Post postParam)
        {
            var like = _iLikeUI.getLikeInPost(postParam.id);
            List<LikeViewModel> likes = new List<LikeViewModel>();
            foreach (var l in like)
            {
                likes.Add(new LikeViewModel(l));
            }

            return likes;
        }


    }
}