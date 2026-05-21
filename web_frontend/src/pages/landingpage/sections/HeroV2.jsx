import React, { useState, useEffect } from "react";
import { HiOutlineArrowLeft, HiOutlineArrowDownTray, HiOutlineChevronDown } from "react-icons/hi2";

export default function HeroV2({ isLoaded }) {
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 50) {
        setScrolled(true);
      } else {
        setScrolled(false);
      }
    };
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <section className={`relative min-h-screen flex flex-col bg-[#050505] selection:bg-[#D9B07C] selection:text-black transition-all duration-1000 ${isLoaded ? 'translate-y-0 opacity-100' : 'translate-y-4 opacity-0'}`}>


      <div className="absolute inset-0 w-full h-full overflow-hidden pointer-events-none z-0">
        <video
          autoPlay
          loop
          muted
          playsInline
          className="absolute top-1/2 left-1/2 min-w-full min-h-full -translate-x-1/2 -translate-y-1/2 object-cover opacity-40 mix-blend-luminosity"
        >
          <source src="/videos/bgg.mp4" type="video/mp4" />
        </video>

        <div className="absolute inset-0 bg-gradient-to-b from-[#050505]/90 via-[#050505]/60 to-[#050505]"></div>
        
        {/* Ambient Backdrop Orbs */}
        <div className="absolute top-[20%] right-[10%] w-[300px] md:w-[500px] h-[300px] md:h-[500px] bg-[#D9B07C]/5 rounded-full blur-[100px] md:blur-[150px] pointer-events-none animate-pulse z-0" />
        <div className="absolute bottom-[30%] left-[5%] w-[250px] md:w-[400px] h-[250px] md:h-[400px] bg-[#D9B07C]/3 rounded-full blur-[90px] md:blur-[130px] pointer-events-none z-0" />
      </div>


      <nav className={`fixed top-0 left-0 right-0 z-[100] px-6 transition-all duration-500 ${
        scrolled 
          ? "py-3 bg-[#050505]/85 backdrop-blur-lg border-b border-[#D9B07C]/15 shadow-[0_10px_30px_-10px_rgba(0,0,0,0.5)]" 
          : "py-5 bg-[#050505]/10 backdrop-blur-sm border-b border-white/5"
      }`}>
        <div className="max-w-7xl mx-auto flex items-center justify-between">

          <a href="#hero" className="flex items-center gap-2 group">
            <div className="w-8 h-8 rounded-lg bg-gradient-to-tr from-[#D9B07C] to-[#FFDFB9] flex items-center justify-center shadow-[0_0_15px_rgba(217,176,124,0.4)] group-hover:scale-105 transition-transform duration-300">
              <span className="text-black font-black text-sm italic">C</span>
            </div>
            <h1 className="text-2xl font-black text-white italic tracking-tighter group-hover:text-[#D9B07C] transition-colors duration-300">
              Car<span className="text-[#D9B07C] group-hover:text-white transition-colors duration-300">Ma</span>
            </h1>
          </a>


          <div className="hidden lg:flex items-center gap-8 text-[15px] font-bold text-gray-300">
            {[
              { label: "الرئيسية", href: "#hero" },
              { label: "خدماتنا", href: "#services" },
              { label: "كيف يعمل", href: "#how-it-works" },
              { label: "لماذا نحن", href: "#why-us" },
              { label: "الأسعار", href: "#pricing" },
              { label: "آراء العملاء", href: "#testimonials" },
            ].map((link, idx) => (
              <a 
                key={idx} 
                href={link.href} 
                className="relative py-1 hover:text-[#D9B07C] transition-all duration-300 after:absolute after:bottom-0 after:right-0 after:w-0 after:h-[2px] after:bg-[#D9B07C] hover:after:w-full after:transition-all after:duration-300"
              >
                {link.label}
              </a>
            ))}
          </div>


          <button className="relative overflow-hidden bg-gradient-to-r from-[#D9B07C] via-[#FFDFB9] to-[#D9B07C] bg-[length:200%_auto] hover:bg-right text-black px-6 py-2.5 rounded-sm font-black text-xs hover:translate-y-[-2px] transition-all duration-300 shadow-[0_10px_20px_-5px_rgba(217,176,124,0.3)] hover:shadow-[0_15px_25px_-5px_rgba(217,176,124,0.4)] flex items-center gap-2 group">
            <span className="relative z-10 flex items-center gap-2">
              <HiOutlineArrowDownTray className="text-sm group-hover:translate-y-[1px] transition-transform duration-300" />
              تحميل التطبيق
            </span>
            <span className="absolute inset-0 w-full h-full bg-gradient-to-r from-transparent via-white/30 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-700 ease-out" />
          </button>
        </div>
      </nav>


      <div className="relative z-10 flex-grow flex items-center pt-24 lg:pt-20">
        <div className="max-w-7xl mx-auto px-6 w-full flex flex-col items-center justify-center gap-12 text-center">
          {/* Main Text Content Area - Centered */}
          <div className="w-full max-w-4xl flex flex-col items-center">
            {/* Top Label */}
            <div 
              className="flex items-center justify-center gap-4 mb-6 md:mb-10"
              data-aos="fade-down"
              data-aos-duration="1000"
              data-aos-delay="100"
            >
              <div className="w-10 md:w-16 h-[1px] bg-[#D9B07C]/30"></div>
              <span className="text-[11px] md:text-[15px] uppercase tracking-[0.2em] md:tracking-[0.25em] font-bold text-[#D9B07C]/80">أفضل خدمة سيارات في المنطقة</span>
              <div className="w-10 md:w-16 h-[1px] bg-[#D9B07C]/30"></div>
            </div>


            <h2 
              className="text-5xl sm:text-7xl lg:text-[90px] font-black leading-[1.0] tracking-tighter bg-clip-text text-transparent bg-gradient-to-b from-white via-white to-white/80 pb-2"
              data-aos="fade-up"
              data-aos-duration="1000"
              data-aos-delay="250"
            >
              جيل جديد
            </h2>
            <h2 
              className="text-5xl sm:text-7xl lg:text-[90px] font-black leading-[1.0] tracking-tighter bg-clip-text text-transparent bg-gradient-to-r from-[#D9B07C] via-[#FFDFB9] to-[#D9B07C] mb-8 md:mb-10 pb-2"
              data-aos="fade-up"
              data-aos-duration="1000"
              data-aos-delay="400"
            >
              من خدمات السيارات
            </h2>

            {/* Description */}
            <p 
              className="text-gray-300 text-base md:text-[18px] leading-relaxed mb-10 md:mb-14 max-w-2xl mx-auto bg-white/5 backdrop-blur-sm py-3 px-8 rounded-full border border-white/5 w-fit"
              data-aos="fade-up"
              data-aos-duration="1000"
              data-aos-delay="550"
            >
              حلول سريعة، شكل احترافي، وجودة تفرق من أول مرة.
            </p>

            {/* CTA Group */}
            <div 
              className="flex flex-col sm:flex-row items-center justify-center gap-5 w-full sm:w-auto"
              data-aos="fade-up"
              data-aos-duration="1000"
              data-aos-delay="700"
            >
              <button className="relative overflow-hidden w-full sm:w-auto bg-gradient-to-r from-[#D9B07C] via-[#FFDFB9] to-[#D9B07C] bg-[length:200%_auto] text-black px-10 py-5 rounded-sm font-black text-sm hover:bg-right hover:translate-y-[-4px] hover:shadow-[0_20px_45px_-10px_rgba(217,176,124,0.5)] transition-all duration-500 shadow-[0_20px_40px_-15px_rgba(217,176,124,0.3)] flex items-center justify-center gap-4 group">
                <span className="relative z-10 flex items-center gap-4">
                  احجز موعدك الآن
                  <HiOutlineArrowLeft className="group-hover:translate-x-[-8px] transition-transform duration-300" size={20} />
                </span>
                {/* Metallic Shine Sweep */}
                <span className="absolute inset-0 w-full h-full bg-gradient-to-r from-transparent via-white/30 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-1000 ease-out" />
              </button>
              <a
                href="#services"
                className="w-full sm:w-auto border border-white/10 bg-white/5 backdrop-blur-md text-white px-10 py-5 rounded-sm font-bold text-sm hover:bg-[#D9B07C]/10 hover:border-[#D9B07C]/30 hover:text-[#D9B07C] hover:translate-y-[-4px] transition-all duration-300 flex items-center justify-center gap-2 group"
              >
                استكشف خدماتنا
                <HiOutlineChevronDown className="group-hover:translate-y-[4px] transition-transform duration-300 text-lg" />
              </a>
            </div>
          </div>


        </div>
      </div>

      {/* Scrolling Services Marquee */}
      <div className="absolute bottom-0 left-0 w-full bg-[#D9B07C] py-3 z-20 overflow-hidden">
        <marquee behavior="scroll" direction="left" scrollamount="8" className="flex items-center">
          <div className="flex items-center gap-12 text-black font-black text-sm whitespace-nowrap">
            {/* Set 1 */}
            <span>تغيير البطارية</span> <span className="text-[8px]">◆</span>
            <span>تغيير الزيت</span> <span className="text-[8px]">◆</span>
            <span>خدمة الإطارات</span> <span className="text-[8px]">◆</span>
            <span>غسيل السيارة</span> <span className="text-[8px]">◆</span>
            <span>خدمة الطوارئ</span> <span className="text-[8px]">◆</span>
            <span>خدمة الونش</span>
            <span className="mx-16"></span>

            {/* Set 2 */}
            <span>تغيير البطارية</span> <span className="text-[8px]">◆</span>
            <span>تغيير الزيت</span> <span className="text-[8px]">◆</span>
            <span>خدمة الإطارات</span> <span className="text-[8px]">◆</span>
            <span>غسيل السيارة</span> <span className="text-[8px]">◆</span>
            <span>خدمة الطوارئ</span> <span className="text-[8px]">◆</span>
            <span>خدمة الونش</span>
            <span className="mx-16"></span>

            {/* Set 3 */}
            <span>تغيير البطارية</span> <span className="text-[8px]">◆</span>
            <span>تغيير الزيت</span> <span className="text-[8px]">◆</span>
            <span>خدمة الإطارات</span> <span className="text-[8px]">◆</span>
            <span>غسيل السيارة</span> <span className="text-[8px]">◆</span>
            <span>خدمة الطوارئ</span> <span className="text-[8px]">◆</span>
            <span>خدمة الونش</span>
            <span className="mx-16"></span>

            {/* Set 4 */}
            <span>تغيير البطارية</span> <span className="text-[8px]">◆</span>
            <span>تغيير الزيت</span> <span className="text-[8px]">◆</span>
            <span>خدمة الإطارات</span> <span className="text-[8px]">◆</span>
            <span>غسيل السيارة</span> <span className="text-[8px]">◆</span>
            <span>خدمة الطوارئ</span> <span className="text-[8px]">◆</span>
            <span>خدمة الونش</span>
            <span className="mx-16"></span>
          </div>
        </marquee>
      </div>

      {/* Subtle Bottom Ambient Glow */}
      <div className="absolute bottom-10 left-0 w-full h-[30vh] bg-gradient-to-t from-[#D9B07C]/5 to-transparent pointer-events-none"></div>
    </section>
  );
}
