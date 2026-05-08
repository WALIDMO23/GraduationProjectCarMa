import { Outlet } from "react-router-dom";
import bgImage from "../assets/login page.jpg";

export default function AuthLayout() {

  return (
    <div 
      className="min-h-screen w-full flex items-center justify-center p-4 font-tajawal bg-cover bg-center bg-no-repeat relative overflow-hidden"
      style={{ backgroundImage: `linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url(${bgImage})` }}
    >
      <div data-aos="zoom-in" data-aos-duration="800" className="w-full max-w-[500px] relative z-10">
        <Outlet />
      </div>
    </div>
  );
}