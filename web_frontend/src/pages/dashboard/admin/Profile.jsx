import React, { useState, useEffect, useRef } from 'react';
import { 
  User, 
  Mail, 
  Phone, 
  Briefcase, 
  Calendar, 
  Clock, 
  Shield, 
  CheckCircle2, 
  Edit3,
  Camera,
  Activity,
  Bell,
  Settings,
  FileText,
  Lock,
  Smartphone,
  Loader2,
  AlertCircle,
  X
} from 'lucide-react';
import DashboardHeader from '../../../component/dashboard/DashboardHeader';
import { getProfile, uploadProfileImage, updateProfile } from '../../../services/authService';
import { getActivityLogs } from '../../../services/adminService';
import Model from '../../../component/ui/Model';

const Profile = () => {
  const [profileData, setProfileData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState(null);
  const [showImagePopup, setShowImagePopup] = useState(false);
  const fileInputRef = useRef(null);

  // Edit Profile Modal state
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [editFormData, setEditFormData] = useState({ name: '', email: '', phoneNumber: '' });
  const [editSubmitting, setEditSubmitting] = useState(false);
  const [editError, setEditError] = useState(null);
  const [editUploading, setEditUploading] = useState(false);
  const editFileInputRef = useRef(null);

  useEffect(() => {
    const handleKeyDown = (e) => {
      if (e.key === 'Escape') {
        setShowImagePopup(false);
      }
    };
    if (showImagePopup) {
      document.body.style.overflow = 'hidden';
      window.addEventListener('keydown', handleKeyDown);
    } else {
      document.body.style.overflow = 'unset';
    }
    return () => {
      document.body.style.overflow = 'unset';
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [showImagePopup]);

  const [activities, setActivities] = useState([]);
  const [activitiesLoading, setActivitiesLoading] = useState(true);

  const fetchProfileData = async () => {
    try {
      setLoading(true);
      const response = await getProfile();
      setProfileData(response.data);
    } catch (err) {
      console.error("Error fetching profile:", err);
      setError("فشل تحميل بيانات الملف الشخصي");
    } finally {
      setLoading(false);
    }
  };

  const fetchActivities = async () => {
    try {
      setActivitiesLoading(true);
      const response = await getActivityLogs(1, 10);
      setActivities(response.data.items || []);
    } catch (err) {
      console.error("Error fetching activities:", err);
    } finally {
      setActivitiesLoading(false);
    }
  };

  useEffect(() => {
    fetchProfileData();
    fetchActivities();
  }, []);

  // ---- Edit Profile Modal Handlers ----
  const openEditModal = () => {
    setEditFormData({
      name: profileData?.name || '',
      email: profileData?.email || '',
      phoneNumber: profileData?.phoneNumber || '',
    });
    setEditError(null);
    setIsEditModalOpen(true);
  };

  const closeEditModal = () => {
    setIsEditModalOpen(false);
    setEditError(null);
  };

  const handleEditInputChange = (e) => {
    const { name, value } = e.target;
    setEditFormData(prev => ({ ...prev, [name]: value }));
    if (editError) setEditError(null);
  };

  const handleEditPhotoClick = () => {
    editFileInputRef.current?.click();
  };

  const handleEditPhotoChange = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (!file.type.startsWith('image/')) {
      alert('يرجى اختيار ملف صورة صحيح');
      return;
    }
    try {
      setEditUploading(true);
      await uploadProfileImage(file);
      const response = await getProfile();
      setProfileData(response.data);
    } catch (err) {
      console.error('Error uploading image:', err);
      alert('فشل رفع الصورة. يرجى المحاولة مرة أخرى.');
    } finally {
      setEditUploading(false);
    }
  };

  const handleEditSubmit = async (e) => {
    e.preventDefault();
    setEditSubmitting(true);
    setEditError(null);
    try {
      await updateProfile(editFormData);
      const response = await getProfile();
      setProfileData(response.data);
      closeEditModal();
    } catch (err) {
      console.error('Error updating profile:', err);
      if (err.response?.status === 409) {
        setEditError(err.response.data?.message || 'البيانات مستخدمة بالفعل');
      } else {
        setEditError('حدث خطأ أثناء تحديث البيانات. يرجى المحاولة مرة أخرى.');
      }
    } finally {
      setEditSubmitting(false);
    }
  };

  const handleCameraClick = () => {
    fileInputRef.current?.click();
  };

  const handleFileChange = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // Validate file type
    if (!file.type.startsWith('image/')) {
      alert('يرجى اختيار ملف صورة صحيح');
      return;
    }

    try {
      setUploading(true);
      await uploadProfileImage(file);
      // Refresh profile data to show the new image
      const response = await getProfile();
      setProfileData(response.data);
      // Optional: Show success message
      window.location.reload();
    } catch (err) {
      console.error("Error uploading image:", err);
      alert('فشل رفع الصورة. يرجى المحاولة مرة أخرى.');
    } finally {
      setUploading(false);
    }
  };

  const getActionDetails = (action) => {
    switch (action) {
      case 'AcceptOrder':
        return {
          title: 'قبول طلب صيانة',
          icon: CheckCircle2,
          color: 'text-emerald-400',
          bg: 'bg-emerald-500/10'
        };
      case 'RejectOrder':
        return {
          title: 'رفض طلب صيانة',
          icon: X,
          color: 'text-red-400',
          bg: 'bg-red-500/10'
        };
      case 'UpdateProfile':
        return {
          title: 'تعديل الملف الشخصي',
          icon: Edit3,
          color: 'text-blue-400',
          bg: 'bg-blue-500/10'
        };
      case 'UpdateProfileImage':
        return {
          title: 'تغيير صورة الملف الشخصي',
          icon: Camera,
          color: 'text-purple-400',
          bg: 'bg-purple-500/10'
        };
      default:
        return {
          title: 'نشاط للمسؤول',
          icon: Settings,
          color: 'text-[#D9B07C]',
          bg: 'bg-[#D9B07C]/10'
        };
    }
  };

  const formatActivityTime = (dateStr) => {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    const now = new Date();
    const diffMs = now - date;
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);

    if (diffMins < 1) return 'الآن';
    if (diffMins < 60) return `منذ ${diffMins} د`;
    if (diffHours < 24) return `منذ ${diffHours} س`;
    if (diffDays === 1) return 'أمس';
    if (diffDays < 7) return `منذ ${diffDays} ي`;
    return date.toLocaleDateString('ar-EG', { month: 'short', day: 'numeric' });
  };

  if (loading && !profileData) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#0a0a0a]">
        <div className="flex flex-col items-center gap-4">
          <Loader2 className="w-12 h-12 text-[#D9B07C] animate-spin" />
          <p className="text-slate-400 font-bold animate-pulse">جاري تحميل الملف الشخصي...</p>
        </div>
      </div>
    );
  }

  if (error && !profileData) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#0a0a0a] p-4">
        <div className="bg-[#121212] border border-red-500/20 p-8 rounded-[2.5rem] text-center max-w-md w-full">
          <AlertCircle className="w-16 h-16 text-red-500 mx-auto mb-4" />
          <h2 className="text-2xl font-black text-white mb-2">عذراً، حدث خطأ</h2>
          <p className="text-slate-400 font-bold mb-6">{error}</p>
          <button 
            onClick={() => window.location.reload()}
            className="w-full bg-[#D9B07C] text-black py-4 rounded-2xl font-black hover:brightness-110 transition-all"
          >
            إعادة المحاولة
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="font-tajawal min-h-screen pb-10">
      <DashboardHeader
        title="الملف الشخصي"
        subtitle="متابعة وإدارة الحساب الشخصي والصلاحيات"
      />

      {/* Main Profile Banner */}
      <div className="bg-[#121212] rounded-[2.5rem] border border-white/5 shadow-2xl overflow-hidden mb-8 relative">
        {/* Top Purple Banner Area */}
        <div className="h-40 md:h-48 bg-gradient-to-r from-purple-600 via-indigo-600 to-blue-600 relative">
          <div className="absolute inset-0 bg-black/20 mix-blend-overlay"></div>
        </div>

        {/* Profile Info Area */}
        <div className="px-8 pb-8 pt-0 relative flex flex-col md:flex-row items-end md:items-center justify-between gap-6" dir="rtl">
          <div className="flex items-center gap-6 w-full md:w-auto mt-[-4rem] relative z-10">
            {/* Avatar */}
            <div className="relative group shrink-0">
              <div className="h-28 w-28 md:h-32 md:w-32 rounded-full bg-[#121212] p-2 flex items-center justify-center shadow-xl relative">
                {uploading && (
                  <div className="absolute inset-0 z-20 bg-black/60 rounded-full flex items-center justify-center">
                    <Loader2 className="w-10 h-10 text-[#D9B07C] animate-spin" />
                  </div>
                )}
                {profileData?.profileImageUrl ? (
                  <img 
                    src={profileData.profileImageUrl} 
                    alt={profileData.name}
                    className="h-full w-full rounded-full object-cover border border-[#D9B07C]/30 hover:border-[#D9B07C] cursor-pointer transition-all duration-300 hover:scale-105"
                    onClick={() => setShowImagePopup(true)}
                  />
                ) : (
                  <div className="h-full w-full rounded-full bg-purple-600/20 border border-purple-500/30 flex items-center justify-center text-purple-400">
                    <User size={64} strokeWidth={1.5} />
                  </div>
                )}
              </div>
              
              <input 
                type="file" 
                ref={fileInputRef} 
                onChange={handleFileChange} 
                accept="image/*" 
                className="hidden" 
              />
              
              <button 
                onClick={handleCameraClick}
                disabled={uploading}
                className="absolute bottom-2 left-2 bg-[#D9B07C] text-black p-2 rounded-full shadow-lg opacity-0 group-hover:opacity-100 transition-opacity translate-y-2 group-hover:translate-y-0 z-30"
              >
                <Camera size={16} />
              </button>
            </div>

            {/* User Details */}
            <div className="text-right pt-16 md:pt-12">
              <h2 className="text-2xl md:text-3xl font-black text-white mb-3">{profileData?.name || 'مستخدم CarMa'}</h2>
              <div className="flex flex-wrap items-center gap-3">
                <span className="text-slate-400 font-bold text-sm">
                  {profileData?.role === 'admin' ? 'مدير المنصة • الإدارة العليا' : profileData?.role || 'عضو المنصة'}
                </span>
                <span className="h-1.5 w-1.5 rounded-full bg-slate-600"></span>
                <span className="inline-flex items-center gap-1.5 px-3 py-1 bg-emerald-500/10 text-emerald-400 text-xs font-black rounded-lg border border-emerald-500/20">
                  <CheckCircle2 size={12} /> نشط
                </span>
                <span className="inline-flex items-center gap-1.5 px-3 py-1 bg-purple-500/10 text-purple-400 text-xs font-black rounded-lg border border-purple-500/20">
                  <Shield size={12} /> {profileData?.role === 'admin' ? 'مدير النظام' : 'مستخدم'}
                </span>
              </div>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="w-full md:w-auto flex justify-end mt-4 md:mt-0 relative z-10">
            <button onClick={openEditModal} className="flex items-center gap-2 bg-white/5 hover:bg-white/10 border border-white/10 text-white px-5 py-2.5 rounded-xl text-sm font-bold transition-all shadow-xl">
              <Edit3 size={16} />
              تعديل الملف الشخصي
            </button>
          </div>
        </div>
      </div>

      <div className="mb-5">
       
        <div className="flex gap-[12px]">
          
          {/* Personal Information */}
          <div className="bg-[#121212] p-8 rounded-[2.5rem] border border-white/5 shadow-xl w-[70%]">
            <h3 className="text-xl font-black text-white mb-8 flex items-center gap-3">
              <User className="text-[#D9B07C]" size={24} />
              المعلومات الشخصية
            </h3>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="flex items-center gap-4 p-4 rounded-2xl bg-white/5 border border-white/5">
                <div className="w-12 h-12 rounded-xl bg-blue-500/10 text-blue-400 flex items-center justify-center shrink-0">
                  <User size={20} />
                </div>
                <div>
                  <p className="text-xs text-slate-500 font-bold mb-1">الاسم الكامل</p>
                  <p className="text-sm font-black text-white">{profileData?.name || 'غير متوفر'}</p>
                </div>
              </div>

              <div className="flex items-center gap-4 p-4 rounded-2xl bg-white/5 border border-white/5">
                <div className="w-12 h-12 rounded-xl bg-purple-500/10 text-purple-400 flex items-center justify-center shrink-0">
                  <Briefcase size={20} />
                </div>
                <div>
                  <p className="text-xs text-slate-500 font-bold mb-1">المسمى الوظيفي</p>
                  <p className="text-sm font-black text-white">{profileData?.role === 'admin' ? 'مدير المنصة' : 'موظف'}</p>
                </div>
              </div>

              <div className="flex items-center gap-4 p-4 rounded-2xl bg-white/5 border border-white/5">
                <div className="w-12 h-12 rounded-xl bg-emerald-500/10 text-emerald-400 flex items-center justify-center shrink-0">
                  <Mail size={20} />
                </div>
                <div>
                  <p className="text-xs text-slate-500 font-bold mb-1">البريد الإلكتروني</p>
                  <p className="text-sm font-black text-white">{profileData?.email || 'غير متوفر'}</p>
                </div>
              </div>

              <div className="flex items-center gap-4 p-4 rounded-2xl bg-white/5 border border-white/5">
                <div className="w-12 h-12 rounded-xl bg-[#D9B07C]/10 text-[#D9B07C] flex items-center justify-center shrink-0">
                  <Phone size={20} />
                </div>
                <div>
                  <p className="text-xs text-slate-500 font-bold mb-1">رقم الهاتف</p>
                  <p className="text-sm font-black text-white" dir="ltr">{profileData?.phoneNumber || 'غير متوفر'}</p>
                </div>
              </div>
            </div>
              {/* System Information */}
          <div className="mt-8">
            <h3 className="text-xl font-black text-white mb-6 flex items-center gap-3">
              <Activity className="text-[#D9B07C]" size={24} />
              معلومات النظام
            </h3>
            
            <div className="space-y-4">
              <div className="flex items-center gap-4 p-4 rounded-2xl bg-white/5 border border-white/5">
                <div className="w-10 h-10 rounded-xl bg-blue-500/10 text-blue-400 flex items-center justify-center shrink-0">
                  <Calendar size={18} />
                </div>
                <div>
                  <p className="text-xs text-slate-500 font-bold mb-1">تاريخ الانضمام</p>
                  <p className="text-sm font-black text-white" dir="ltr">2024-01-01</p>
                </div>
              </div>

              <div className="flex items-center gap-4 p-4 rounded-2xl bg-white/5 border border-white/5">
                <div className="w-10 h-10 rounded-xl bg-emerald-500/10 text-emerald-400 flex items-center justify-center shrink-0">
                  <Clock size={18} />
                </div>
                <div>
                  <p className="text-xs text-slate-500 font-bold mb-1">آخر تسجيل دخول</p>
                  <p className="text-sm font-black text-white" dir="ltr">2026-05-15 09:30 PM</p>
                </div>
              </div>
            </div>
          </div>
          </div>

     

          {/* Recent Activities */}
          <div className="bg-[#121212] p-8 rounded-[2.5rem] border border-white/5 shadow-xl relative overflow-hidden w-[30%]">
            <div className="absolute top-0 left-0 w-32 h-32 bg-[#D9B07C]/5 blur-3xl rounded-full -ml-16 -mt-16"></div>
            <h3 className="text-xl font-black text-white mb-6 flex items-center gap-3 relative z-10">
              <Activity className="text-[#D9B07C]" size={24} />
              النشاطات الأخيرة
            </h3>
            
            <div className="space-y-6 relative z-10">
              {activitiesLoading ? (
                <div className="flex flex-col items-center py-8 gap-3">
                  <Loader2 className="w-8 h-8 text-[#D9B07C] animate-spin" />
                  <p className="text-xs text-slate-500 font-bold animate-pulse">جاري تحميل النشاطات...</p>
                </div>
              ) : activities.length === 0 ? (
                <div className="text-center py-8">
                  <Activity className="w-12 h-12 text-slate-600 mx-auto mb-2 opacity-50" />
                  <p className="text-sm text-slate-400 font-bold">لا توجد نشاطات مسجلة بعد</p>
                </div>
              ) : (
                activities.map((activity) => {
                  const details = getActionDetails(activity.action);
                  const IconComponent = details.icon;
                  return (
                    <div key={activity.id} className="flex items-start gap-4">
                      <div className={`mt-1 w-10 h-10 rounded-xl flex items-center justify-center shrink-0 ${details.bg} ${details.color}`}>
                        <IconComponent size={18} />
                      </div>
                      <div className="flex-1 text-right" dir="rtl">
                        <p className="text-sm font-black text-white">{details.title}</p>
                        <p className="text-xs text-slate-400 font-bold mt-1">{activity.description}</p>
                      </div>
                      <span className="text-[10px] text-slate-500 font-black whitespace-nowrap bg-white/5 px-2 py-1 rounded-md">
                        {formatActivityTime(activity.createdAt)}
                      </span>
                    </div>
                  );
                })
              )}
            </div>
          </div>
          {/* Section removed */}
        </div>

   
      </div>

      {/* Security Banner */}
      <div className="bg-[#121212] rounded-[2.5rem] border border-white/5 p-8 flex flex-col md:flex-row items-center justify-between gap-6 shadow-xl relative overflow-hidden" dir="rtl">
        <div className="absolute right-0 top-0 w-64 h-64 bg-emerald-500/5 blur-[80px] rounded-full"></div>
        <div className="absolute left-0 bottom-0 w-64 h-64 bg-[#D9B07C]/5 blur-[80px] rounded-full"></div>
        
        <div className="flex items-center gap-6 relative z-10 w-full md:w-auto">
          <div className="w-16 h-16 rounded-2xl bg-white/5 flex items-center justify-center text-white shrink-0 border border-white/5">
            <Shield size={32} />
          </div>
          <div>
            <h3 className="text-2xl font-black text-white mb-2">حساب آمن ومحمي</h3>
            <p className="text-sm text-slate-400 font-bold leading-relaxed max-w-xl">
              حسابك محمي بأعلى معايير الأمان. المصادقة الثنائية مفعلة وجميع الأنشطة مسجلة ومراقبة لضمان أمان المنصة.
            </p>
          </div>
        </div>

        <div className="flex items-center justify-end gap-4 relative z-10 w-full md:w-auto">
          <div className="flex flex-col items-center bg-[#0a0a0a] px-6 py-4 rounded-2xl border border-white/5 w-1/2 md:w-auto">
            <Lock size={20} className="text-emerald-400 mb-2" />
            <span className="text-xs text-white font-black mb-1">كلمة المرور</span>
            <span className="text-[10px] text-emerald-400 font-bold">قوية جداً</span>
          </div>
          <div className="flex flex-col items-center bg-[#0a0a0a] px-6 py-4 rounded-2xl border border-white/5 w-1/2 md:w-auto">
            <Smartphone size={20} className="text-[#D9B07C] mb-2" />
            <span className="text-xs text-white font-black mb-1">المصادقة الثنائية</span>
            <span className="text-[10px] text-[#D9B07C] font-bold">مفعلة</span>
          </div>
        </div>
      </div>

      {/* Premium Glassmorphic Image Preview Modal */}
      {showImagePopup && profileData?.profileImageUrl && (
        <div 
          className="fixed inset-0 z-[200] flex items-center justify-center p-4 bg-black/95 backdrop-blur-md transition-all duration-300 animate-in fade-in"
          onClick={() => setShowImagePopup(false)}
        >
          {/* Close button outside/on top */}
          <button 
            className="absolute top-6 right-6 text-white/70 hover:text-white bg-white/10 hover:bg-white/20 p-3 rounded-full transition-all duration-300 backdrop-blur-sm z-50 border border-white/10 shadow-lg"
            onClick={() => setShowImagePopup(false)}
          >
            <X size={24} />
          </button>

          {/* Modal Container */}
          <div 
            className="relative max-w-4xl max-h-[85vh] w-auto h-auto rounded-[2.5rem] overflow-hidden border border-white/10 shadow-2xl bg-[#121212]/50 p-2 backdrop-blur-xl animate-in zoom-in-95 duration-300"
            onClick={(e) => e.stopPropagation()}
          >
            <img 
              src={profileData.profileImageUrl} 
              alt={profileData.name}
              className="max-w-full max-h-[80vh] rounded-[2rem] object-contain shadow-2xl mx-auto border border-white/5"
            />
            {/* Image Details overlay */}
            <div className="absolute bottom-6 left-6 right-6 bg-[#0a0a0a]/80 backdrop-blur-md px-6 py-4 rounded-2xl border border-white/5 flex items-center justify-between gap-4 text-right" dir="rtl">
              <div>
                <p className="text-sm font-black text-white">{profileData.name}</p>
                <p className="text-xs text-[#D9B07C] font-bold mt-1">صورة الملف الشخصي</p>
              </div>
              <span className="text-[10px] text-slate-500 font-bold bg-white/5 px-2 py-1 rounded-md">انقر في أي مكان للإغلاق</span>
            </div>
          </div>
        </div>
      )}

      {/* Edit Profile Modal */}
      <Model
        isOpen={isEditModalOpen}
        onClose={closeEditModal}
        title="تعديل الملف الشخصي"
        showCloseButton={true}
        closeOnBackdropClick={false}
      >
        <form onSubmit={handleEditSubmit} className="space-y-6 text-right" dir="rtl">
          {/* Profile Photo */}
          <div className="flex flex-col items-center gap-4 pb-6 border-b border-white/5">
            <div className="relative group">
              <div className="h-28 w-28 rounded-full bg-[#121212] p-1.5 flex items-center justify-center shadow-xl relative">
                {editUploading && (
                  <div className="absolute inset-0 z-20 bg-black/60 rounded-full flex items-center justify-center">
                    <Loader2 className="w-8 h-8 text-[#D9B07C] animate-spin" />
                  </div>
                )}
                {profileData?.profileImageUrl ? (
                  <img
                    src={profileData.profileImageUrl}
                    alt={profileData.name}
                    className="h-full w-full rounded-full object-cover border border-[#D9B07C]/30"
                  />
                ) : (
                  <div className="h-full w-full rounded-full bg-purple-600/20 border border-purple-500/30 flex items-center justify-center text-purple-400">
                    <User size={48} strokeWidth={1.5} />
                  </div>
                )}
              </div>
              <input
                type="file"
                ref={editFileInputRef}
                onChange={handleEditPhotoChange}
                accept="image/*"
                className="hidden"
              />
              <button
                type="button"
                onClick={handleEditPhotoClick}
                disabled={editUploading}
                className="absolute bottom-1 left-1 bg-[#D9B07C] text-black p-2 rounded-full shadow-lg opacity-0 group-hover:opacity-100 transition-all translate-y-2 group-hover:translate-y-0 z-30 hover:scale-110"
              >
                <Camera size={14} />
              </button>
            </div>
            <p className="text-xs text-slate-500 font-bold">اضغط على أيقونة الكاميرا لتغيير الصورة</p>
          </div>

          {/* Error Message */}
          {editError && (
            <div className="flex items-center gap-3 bg-red-500/10 border border-red-500/20 text-red-400 px-5 py-3.5 rounded-2xl text-sm font-bold">
              <AlertCircle size={18} className="shrink-0" />
              {editError}
            </div>
          )}

          {/* Form Fields */}
          <div className="space-y-5">
            <div className="space-y-2">
              <label className="text-sm font-bold text-white flex items-center gap-2">
                <User size={14} className="text-[#D9B07C]" />
                الاسم الكامل
              </label>
              <input
                required
                type="text"
                name="name"
                value={editFormData.name}
                onChange={handleEditInputChange}
                className="w-full bg-[#0a0a0a] border border-white/10 rounded-xl px-4 py-3 text-white focus:border-[#D9B07C] focus:ring-1 focus:ring-[#D9B07C] outline-none transition-all placeholder-slate-600"
                placeholder="أدخل الاسم الكامل"
              />
            </div>

            <div className="space-y-2">
              <label className="text-sm font-bold text-white flex items-center gap-2">
                <Mail size={14} className="text-[#D9B07C]" />
                البريد الإلكتروني
              </label>
              <input
                required
                type="email"
                name="email"
                value={editFormData.email}
                onChange={handleEditInputChange}
                className="w-full bg-[#0a0a0a] border border-white/10 rounded-xl px-4 py-3 text-white focus:border-[#D9B07C] focus:ring-1 focus:ring-[#D9B07C] outline-none transition-all text-left placeholder-slate-600" dir="ltr"
                placeholder="example@email.com"
              />
            </div>

            <div className="space-y-2">
              <label className="text-sm font-bold text-white flex items-center gap-2">
                <Phone size={14} className="text-[#D9B07C]" />
                رقم الهاتف
              </label>
              <input
                required
                type="text"
                name="phoneNumber"
                value={editFormData.phoneNumber}
                onChange={handleEditInputChange}
                className="w-full bg-[#0a0a0a] border border-white/10 rounded-xl px-4 py-3 text-white focus:border-[#D9B07C] focus:ring-1 focus:ring-[#D9B07C] outline-none transition-all text-left placeholder-slate-600" dir="ltr"
                placeholder="01XXXXXXXXX"
              />
            </div>
          </div>

          {/* Action Buttons */}
          <div className="pt-6 border-t border-white/5 flex gap-3">
            <button
              type="submit"
              disabled={editSubmitting}
              className="flex-1 bg-[#D9B07C] hover:bg-[#D9B07C]/90 text-black px-6 py-3.5 rounded-xl font-black transition-all shadow-xl shadow-[#D9B07C]/10 disabled:opacity-50 flex items-center justify-center gap-2"
            >
              {editSubmitting ? <Loader2 size={20} className="animate-spin" /> : 'حفظ التعديلات'}
            </button>
            <button
              type="button"
              onClick={closeEditModal}
              className="px-6 py-3.5 rounded-xl font-black text-white bg-white/5 hover:bg-white/10 transition-all border border-white/5"
            >
              إلغاء
            </button>
          </div>
        </form>
      </Model>

    </div>
  );
};

export default Profile;
