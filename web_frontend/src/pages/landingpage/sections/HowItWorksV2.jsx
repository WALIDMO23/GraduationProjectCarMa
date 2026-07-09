import React from "react";
import { HiOutlineCursorArrowRays, HiOutlinePencilSquare, HiOutlineClipboardDocumentCheck } from "react-icons/hi2";

const LocationIcon = ({ size = 24, className = "" }) => (
  <svg
    version="1.1"
    xmlns="http://www.w3.org/2000/svg"
    width={size}
    height={size}
    viewBox="0 0 50 50"
    className={className}
  >
    <path
      d="M0 0 C4.88949139 2.270121 7.76263748 5.09501294 10 10 C12.23197695 25.2483659 4.62973847 36.34327266 -4 48 C-6.21484375 47.90234375 -6.21484375 47.90234375 -9 47 C-10.76909861 44.85500523 -12.15088336 42.92275244 -13.5625 40.5625 C-13.95236084 39.92578369 -14.34222168 39.28906738 -14.74389648 38.63305664 C-20.39732548 29.2083001 -23.46984264 21.23379731 -22 10 C-17.59387836 0.34042564 -9.81466679 -1.32120515 0 0 Z M-18 9 C-20.28446829 13.56893657 -19.56070138 19.68933891 -18.38671875 24.52734375 C-15.78892492 31.58830761 -11.66611213 38.12191069 -7 44 C-6.34 44 -5.68 44 -5 44 C-3.41799612 41.86264371 -1.97463534 39.74628173 -0.5625 37.5 C0.04646118 36.53259888 0.04646118 36.53259888 0.66772461 35.5456543 C5.47247463 27.77375354 8.77009835 20.38012745 7 11 C4.99883572 7.51785176 2.61165246 4.80582623 -1 3 C-8.53291221 1.9120657 -13.03748238 3.14210458 -18 9 Z"
      fill="currentColor"
      transform="translate(31,1)"
    />
    <path
      d="M0 0 C2 1 2 1 3 3 C3.51981506 6.56444611 3.63102777 9.73794446 2 13 C-1.26205554 14.63102777 -4.43555389 14.51981506 -8 14 C-10 13 -10 13 -11 11 C-11.51981506 7.43555389 -11.63102777 4.26205554 -10 1 C-6.73794446 -0.63102777 -3.56444611 -0.51981506 0 0 Z M-8 4 C-8.16666667 7 -8.16666667 7 -8 10 C-6.88163776 11.34404775 -6.88163776 11.34404775 -4 11.125 C-1.11836224 11.34404775 -1.11836224 11.34404775 0 10 C0.16666667 7 0.16666667 7 0 4 C-1.11836224 2.65595225 -1.11836224 2.65595225 -4 2.875 C-6.88163776 2.65595225 -6.88163776 2.65595225 -8 4 Z"
      fill="currentColor"
      transform="translate(29,11)"
    />
  </svg>
);

const STEPS = [
  {
    number: "1",
    title: "اختر الخدمة",
    description: "حدد الخدمة التي تحتاجها لسيارتك من قائمة خدماتنا المتنوعة",
    icon: <HiOutlineCursorArrowRays size={32} />,
  },
  {
    number: "2",
    title: "سجل طلبك",
    description: "حدد موقعك والوقت المناسب لك لإتمام الخدمة بسهولة",
    icon: <HiOutlinePencilSquare size={32} />,
  },
  {
    number: "3",
    title: "تأكيد الطلب",
    description: "سيتم تأكيد طلبك وموعدك من قبل فريق خدمة العملاء",
    icon: <HiOutlineClipboardDocumentCheck size={32} />,
  },
  {
    number: "4",
    title: "الاستلام في موقعك",
    description: "سيصلك فريقنا المتخصص في الوقت والمكان المحددين",
    icon: <LocationIcon size={32} />,
  },
];

export default function HowItWorksV2() {
  return (
    <section id="how-it-works" className="bg-[#121212] py-32 relative overflow-hidden border-t border-white/5">
      {/* Background Shadow Text */}
      <div className="absolute top-28 left-4 text-[12rem] font-black text-white/[0.02] pointer-events-none select-none hidden lg:block uppercase tracking-tighter">
          Process
      </div>
      <div className="max-w-7xl mx-auto px-6 relative z-10">
        <div data-aos="fade-up" className="mb-24 flex flex-col items-start text-right">
          <div className="flex items-center gap-3 mb-6">
            <span className="text-[#D9B07C] text-[15px] font-bold uppercase tracking-[0.3em]">ببساطة</span>
            <div className="w-12 h-[1px] bg-[#D9B07C]"></div>
          </div>
          <h2 className="text-4xl md:text-5xl font-black text-white mb-6">كيف يعمل Car<span className="text-[#D9B07C]">Ma</span></h2>
          <p className="text-gray-500 max-w-2xl">
            خطوات بسيطة تفصلك عن صيانة سيارتك بأعلى معايير الجودة والاحترافية
          </p>
        </div>

        <div className="relative">
          <div className="flex flex-col lg:flex-row items-center lg:items-start justify-between gap-12 lg:gap-0 relative z-10">
            {STEPS.map((step, index) => (
              <React.Fragment key={index}>
                {/* Step Item */}
                <div
                  className="group text-center lg:w-[200px]"
                  data-aos="fade-left"
                  data-aos-delay={index * 400}
                >
                  <div 
                    className="w-24 h-24 mx-auto mb-8 rounded-full bg-[#050505] border border-[#D9B07C]/20 flex items-center justify-center text-[#D9B07C] group-hover:bg-[#D9B07C] group-hover:text-black group-hover:border-[#D9B07C] group-hover:shadow-[0_0_40px_rgba(217,176,124,0.2)] transition-all duration-700 relative z-10 cursor-pointer"
                  >
                    <div className="relative">
                      {step.icon}
                    </div>
                  </div>
                  <h3 className="text-xl font-bold text-white mb-4 group-hover:text-[#D9B07C] transition-colors duration-300">{step.title}</h3>
                  <p className="text-gray-500 text-sm leading-relaxed max-w-[200px] mx-auto group-hover:text-gray-400 transition-colors duration-300">
                    {step.description}
                  </p>
                </div>

                {/* Connection Line Segment */}
                {index < STEPS.length - 1 && (
                  <div 
                    className="hidden lg:block flex-grow h-[12px] mt-12 overflow-hidden opacity-80 mx-[-30px]"
                    data-aos="fade-left"
                    data-aos-delay={index * 400 + 200}
                  >
                    <div 
                      className="w-full h-full animate-flow-rtl"
                      style={{
                        backgroundImage: `url("data:image/svg+xml,%3Csvg width='20' height='20' viewBox='0 0 20 20' fill='none' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M12 5L7 10L12 15' stroke='%23D9B07C' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E")`,
                        backgroundRepeat: 'repeat-x',
                        backgroundSize: '20px 100%',
                        filter: 'drop-shadow(0 0 3px rgba(217, 176, 124, 0.8))'
                      }}
                    />
                  </div>
                )}
              </React.Fragment>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
