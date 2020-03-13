using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class User
    {
        [Key]
        public int idUser { get; set; }
        public string mail { get; set; }
        public string sifra { get; set; }
        public string korisnickoIme { get; set; }
        public string ime { get; set; }
        public string prezime { get; set; }
        public DateTime datumRegistracije { get; set; }
        public string token { get; set; }
    }
}
