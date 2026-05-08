import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Button from "../../component/ui/Button";
import Input from "../../component/ui/Input";
import { HiOutlineLockClosed, HiOutlineEnvelope, HiOutlineEye, HiOutlineEyeSlash, HiOutlineCog6Tooth, HiOutlineShieldCheck, HiOutlineBolt } from "react-icons/hi2";
import { login } from "../../services/authService";
import { useAuth } from "../../context/AuthContext";

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const { saveAuth, isAuthenticated } = useAuth();
  const navigate = useNavigate();

  // Redirect if already authenticated - Commented out as per user request to access login page directly
  // React.useEffect(() => {
  //   if (isAuthenticated) {
  //     navigate('/admin', { replace: true });
  //   }
  // }, [isAuthenticated, navigate]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const { data } = await login({ email, password });

      // Save token & user data from the API response
      const token = data.token || data.data?.token;
      const user = data.user || data.data?.user || data.data;

      if (token) {
        saveAuth(token, user);
        navigate('/admin');
      } else {
        // If the API returned success but no token, show the message
        setError(data.message || 'حدث خطأ أثناء تسجيل الدخول');
      }
    } catch (err) {
      const msg =
        err.response?.data?.message ||
        err.response?.data?.errors?.[0] ||
        'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="relative flex flex-col items-center justify-center font-sans select-none w-full" dir="rtl">

      {/* Branding */}
      <div className="text-center mb-8">
        <h1 className="text-7xl font-black text-premium-gold italic tracking-tighter drop-shadow-lg flip-animation">CarMa</h1>
        <p className="text-sm text-premium-gold/70 font-bold tracking-[0.25em] mt-2 uppercase">نحافظ على سيارتك بأفضل حال</p>
      </div>

      {/* Feature Badges */}
      <div className="flex gap-10 mb-12">
        <div className="flex flex-col items-center gap-3">
          <div className="w-16 h-16 rounded-full border-2 border-premium-gold/30 flex items-center justify-center bg-premium-gold/5 shadow-lg shadow-premium-gold/5">
            <HiOutlineCog6Tooth className="text-premium-gold" size={32} />
          </div>
          <span className="text-[11px] text-premium-gold font-bold text-center leading-tight">فنيين<br/>خبراء</span>
        </div>
        <div className="flex flex-col items-center gap-3">
          <div className="w-16 h-16 rounded-full border-2 border-premium-gold/30 flex items-center justify-center bg-premium-gold/5 shadow-lg shadow-premium-gold/5">
            <HiOutlineShieldCheck className="text-premium-gold" size={32} />
          </div>
          <span className="text-[11px] text-premium-gold font-bold text-center leading-tight">جودة<br/>عالية</span>
        </div>
        <div className="flex flex-col items-center gap-3">
          <div className="w-16 h-16 rounded-full border-2 border-premium-gold/30 flex items-center justify-center bg-premium-gold/5 shadow-lg shadow-premium-gold/5">
            <HiOutlineBolt className="text-premium-gold" size={32} />
          </div>
          <span className="text-[11px] text-premium-gold font-bold text-center leading-tight">سريع<br/>وموثوق</span>
        </div>
      </div>

      {/* Glass Form Card */}
      <div className="w-full rounded-3xl overflow-hidden px-8 py-10 border border-white/10 bg-white/5 backdrop-blur-2xl shadow-[0_0_60px_0_rgba(0,0,0,0.3)]">
        <h2 className="text-2xl font-black text-premium-gold text-center mb-2">مرحباً بعودتك</h2>
        <p className="text-premium-gold/60 text-sm text-center mb-8 font-medium">سجل دخولك للوصول إلى حسابك</p>

      {error && (
        <div className="mb-4 p-3 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm text-center font-medium">
          {error}
        </div>
      )}

      <form className="space-y-6" onSubmit={handleSubmit}>
        <Input
          label="البريد الإلكتروني"
          labelClassName="text-premium-gold/80"
          icon={<HiOutlineEnvelope className="text-premium-gold/60" size={20} />}
          placeholder="example@mail.com"
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />

        <div className="relative">
          <Input
            label="كلمة المرور"
            labelClassName="text-premium-gold/80"
            type={showPassword ? "text" : "password"}
            icon={<HiOutlineLockClosed className="text-premium-gold/60" size={20} />}
            placeholder="********"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          {password.length > 0 && (
            <button 
              type="button" 
              onClick={() => setShowPassword(!showPassword)}
              className="absolute left-4 top-[45px] text-premium-gold/60 hover:text-premium-gold transition-colors"
            >
              {showPassword ? <HiOutlineEye size={18} /> : <HiOutlineEyeSlash size={18} />}
            </button>
          )}
        </div>

        <div className="flex justify-between items-center px-1 text-xs">
          <label className="flex items-center gap-2 text-premium-gold/60 cursor-pointer font-medium">
            <input type="checkbox" className="w-4 h-4 rounded border-premium-gold/20 text-premium-gold bg-transparent" />
            تذكرني
          </label>
          {/* <a href="#" className="text-premium-gold font-bold hover:underline transition-all">نسيت كلمة المرور؟</a> */}
        </div>

        <Button
          type="submit"
          disabled={loading}
          variant="custom"
          className="w-full bg-premium-gold text-black hover:bg-gold-light h-14 rounded-2xl shadow-xl shadow-premium-gold/20 text-lg font-bold mt-2 transition-all duration-300 disabled:opacity-60 disabled:cursor-not-allowed transform hover:-translate-y-0.5"
        >
          {loading ? 'جاري تسجيل الدخول...' : 'تسجيل الدخول'}
        </Button> 
      </form>
    </div>
    </div>
  );

};
