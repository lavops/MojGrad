using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class History
    {
        [Key]
        public int id { get; set; }

        public DateTime datumRegistracije { get; set; }

        public virtual User user { get; set; }
    }
}
