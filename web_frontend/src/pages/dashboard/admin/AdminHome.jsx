import React from 'react';
import { 
  TrendingUp, 
  Users, 
  Briefcase, 
  DollarSign, 
  Activity,
  Loader2,
  AlertTriangle,
  CheckCircle,
  Clock,
  MapPin,
  Phone
} from 'lucide-react';
import { FiClock, FiCheckCircle, FiRefreshCw, FiCheckSquare, FiXCircle } from 'react-icons/fi';
import DashboardHeader from '../../../component/dashboard/DashboardHeader';
import StatCard from '../../../component/dashboard/StatCard';
import OrderApprovalCard from '../../../component/dashboard/OrderApprovalCard';
import AlertCard from '../../../component/dashboard/AlertCard';
import { updateOrderStatus, acceptOrder, rejectOrder } from '../../../services/adminService';
import { useAdminData } from '../../../context/AdminDataContext';

const AdminHome = () => {
  const { dashboardData: data, loading, error, refreshAll, getStatus, getServiceStyle } = useAdminData();
  console.log(data)

  const handleApprove = async (id) => {
    try {
      await acceptOrder(id);
      refreshAll();
    } catch (err) {
      console.error("Error approving order:", err);
      alert("فشل في قبول الطلب");
    }
  };

  const handleReject = async (id) => {
    try {
      await rejectOrder(id);
      refreshAll();
    } catch (err) {
      console.error("Error rejecting order:", err);
      alert("فشل في رفض الطلب");
    }
  };

  // Map API data to UI stats
  const stats = [
    {
      title: 'إيرادات اليوم',
      value: data?.stats?.todayRevenue !== undefined ? `${data.stats.todayRevenue.toLocaleString()} جنيه` : '0 جنيه',
      trend: '+0%',
      trendUp: true,
      icon: DollarSign,
      iconBg: 'bg-emerald-500/10',
      iconColor: 'text-emerald-400',
    },
    {
      title: 'الورش المتاحة',
      value: data?.stats?.totalTechs || '0',
      subValue: `إجمالي الورش`,
      icon: Users,
      iconBg: 'bg-cyan-500/10',
      iconColor: 'text-cyan-400',
    },
    {
      title: 'مكتملة اليوم',
      value: data?.stats?.completedToday || '0',
      trend: '+0%',
      trendUp: true,
      icon: FiCheckSquare,
      iconBg: 'bg-[#D9B07C]/10',
      iconColor: 'text-[#D9B07C]',
    },
    {
      title: 'جاري التنفيذ',
      value: data?.stats?.inProgressOrders || '0',
      trend: '+0',
      trendUp: true,
      icon: FiRefreshCw,
      iconBg: 'bg-blue-500/10',
      iconColor: 'text-blue-400',
    },
    {
      title: 'قيد المراجعة',
      value: data?.stats?.pendingOrders || '0',
      trend: '+0',
      trendUp: true,
      icon: FiClock,
      iconBg: 'bg-amber-500/10',
      iconColor: 'text-amber-400',
    },
    {
      title: 'إجمالي الطلبات',
      value: data?.stats?.totalOrders ? data.stats.totalOrders.toLocaleString() : '0',
      trend: '+0%',
      trendUp: true,
      icon: TrendingUp,
      iconBg: 'bg-indigo-500/10',
      iconColor: 'text-indigo-400',
    },
  ];

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] font-tajawal">
        <Loader2 className="animate-spin text-primary mb-4" size={48} />
        <p className="text-slate-500 font-bold">جاري تحميل لوحة التحكم...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] font-tajawal">
        <AlertTriangle className="text-red-500 mb-4" size={48} />
        <p className="text-red-600 font-bold">{error}</p>
        <button
          onClick={() => window.location.reload()}
          className="mt-4 px-6 py-2 bg-primary text-white rounded-xl font-bold"
        >
          إعادة المحاولة
        </button>
      </div>
    );
  }

  const pendingOrders = data?.requestsNeedingApproval || [];
  const activeOrders = data?.currentOrders || [];
  const alerts = data?.alerts || [];

  const formatTime = (dateString) => {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' });
  };

  return (
    <div className="font-tajawal min-h-screen">
      <DashboardHeader
        title="لوحة التحكم"
        subtitle="مرحباً بك مجدداً، إليك ملخص العمليات اليوم"
      />

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4 mb-10">
        {stats.map((stat, index) => (
          <StatCard key={index} {...stat} />
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Main Content: Pending Approvals */}
        <div className="lg:col-span-2">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-2xl font-black text-white">طلبات بانتظار الموافقة</h2>
            <button className="text-[#D9B07C] font-black hover:underline text-sm uppercase tracking-widest">عرض الكل</button>
          </div>

          <div className="space-y-4 max-h-[600px] overflow-y-auto pr-2 overflow-x-hidden [&::-webkit-scrollbar]:w-1.5 [&::-webkit-scrollbar-track]:bg-white/5 [&::-webkit-scrollbar-track]:rounded-full [&::-webkit-scrollbar-thumb]:bg-[#D9B07C]/30 hover:[&::-webkit-scrollbar-thumb]:bg-[#D9B07C]/50 [&::-webkit-scrollbar-thumb]:rounded-full transition-all pl-1">
            {pendingOrders.length > 0 ? (
              pendingOrders.map((order, idx) => {
                const serviceStyle = getServiceStyle(order.serviceName);
                return (
                  <OrderApprovalCard
                    key={order.id || idx}
                    id={order.id}
                    service={order.serviceName}
                    customer={order.customerName}
                    phone={order.phoneNumber}
                    time={formatTime(order.createdAt)}
                    location={order.address}
                    price={order.price}
                    rating={order.customerRate || "5.0"}
                    prevOrders={order.customerPrevOrders || "0"}
                    icon={serviceStyle.IconComponent}
                    iconBgClass={serviceStyle.bgClass}
                    iconColorClass={serviceStyle.textColorClass}
                    onApprove={handleApprove}
                    onReject={handleReject}
                  />
                );
              })
            ) : (
              <div className="bg-[#121212] p-12 rounded-[2.5rem] text-center border border-dashed border-white/5 shadow-xl">
                <p className="text-slate-500 font-bold">لا توجد طلبات جديدة حالياً</p>
              </div>
            )}
          </div>

          {/* Active Orders Section */}
          <div className="mt-16">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-2xl font-black text-white">الطلبات النشطة</h2>
              <button className="text-[#D9B07C] font-black hover:underline text-sm uppercase tracking-widest">عرض الكل</button>
            </div>

            <div className="bg-[#121212] rounded-[2.5rem] shadow-2xl border border-white/5 overflow-hidden">
              <div className="max-h-[500px] overflow-auto [&::-webkit-scrollbar]:w-1.5 [&::-webkit-scrollbar]:h-1.5 [&::-webkit-scrollbar-track]:bg-white/5 [&::-webkit-scrollbar-track]:rounded-full [&::-webkit-scrollbar-thumb]:bg-[#D9B07C]/30 hover:[&::-webkit-scrollbar-thumb]:bg-[#D9B07C]/50 [&::-webkit-scrollbar-thumb]:rounded-full transition-all">
                <table className="w-full text-right">
                  <thead>
                    <tr className="bg-white/5">
                      <th className="px-8 py-5 text-xs font-black text-[#D9B07C] uppercase tracking-widest">رقم الطلب</th>
                      <th className="px-8 py-5 text-xs font-black text-[#D9B07C] uppercase tracking-widest">الخدمة</th>
                      <th className="px-8 py-5 text-xs font-black text-[#D9B07C] uppercase tracking-widest">العميل</th>
                      <th className="px-8 py-5 text-xs font-black text-[#D9B07C] uppercase tracking-widest">الحالة</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-white/5">
                    {activeOrders.length > 0 ? (
                      activeOrders.map((order) => {
                        const statusInfo = getStatus(order.status);
                        const serviceStyle = getServiceStyle(order.serviceName);
                        return (
                          <tr key={order.id} className="hover:bg-white/5 transition-all duration-300 group">
                            <td className="px-8 py-5 font-black text-sm text-white">#{order.id}</td>
                            <td className="px-8 py-5">
                              <div className="flex items-center gap-4">
                                <div
                                  className={`h-10 w-10 rounded-xl flex items-center justify-center shrink-0 shadow-lg shadow-black/20 ${serviceStyle.bgClass} ${serviceStyle.textColorClass}`}
                                >
                                  <serviceStyle.IconComponent size={20} />
                                </div>
                                <span className="text-sm font-bold text-slate-300 whitespace-nowrap">{order.serviceName}</span>
                              </div>
                            </td>
                            <td className="px-8 py-5 text-sm font-bold text-slate-400">{order.customerName}</td>
                            <td className="px-8 py-5">
                              <span className={`inline-flex items-center gap-1.5 px-4 py-1.5 rounded-full text-[10px] font-black border transition-all ${statusInfo.bg} ${statusInfo.text} border-white/5`}>
                                <statusInfo.icon size={12} className={statusInfo.value === 'InProgress' ? 'animate-spin' : ''} />
                                {statusInfo.label}
                              </span>
                            </td>
                          </tr>
                        );
                      })
                    ) : (
                      <tr>
                        <td colSpan="4" className="px-8 py-16 text-center text-slate-500 font-bold">لا توجد طلبات نشطة حالياً</td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>


        {/* Sidebar Content: Alerts & Recent Activity */}
        <div className="space-y-8">
          <div>
            <h2 className="text-2xl font-black text-white mb-6">تنبيهات هامة</h2>
            <div className="space-y-4 max-h-[500px] overflow-y-auto pr-2 overflow-x-hidden [&::-webkit-scrollbar]:w-1.5 [&::-webkit-scrollbar-track]:bg-white/5 [&::-webkit-scrollbar-track]:rounded-full [&::-webkit-scrollbar-thumb]:bg-[#D9B07C]/30 hover:[&::-webkit-scrollbar-thumb]:bg-[#D9B07C]/50 [&::-webkit-scrollbar-thumb]:rounded-full transition-all pl-1">
              {alerts.length > 0 ? (
                alerts.map((alert) => {
                  const isOrder = alert.orderStatus !== undefined;
                  return (
                    <AlertCard
                      key={alert.id}
                      id={alert.id}
                      
                      title={isOrder ? `طلب جديد #${alert.id} ${alert.serviceId === 5 ? 'لصيانة طارئة' : alert.serviceId === 6 ? 'لونش' : ''}` : alert.title}
                      description={isOrder ? `طلب خدمة جديد بقيمة ${alert.price} جنيه. ${alert.address && alert.address !== 'string' ? `العنوان: ${alert.address}` : ''}` : alert.description}
                      time={isOrder ? formatTime(alert.createdAt) : alert.time}
                      type={isOrder ? 'warning' : (alert.type === 'urgent' ? 'emergency' : alert.type || 'info')}
                      icon={isOrder ? Clock : (alert.type === 'urgent' ? AlertTriangle : CheckCircle)}
                      onApprove={isOrder && alert.orderStatus === 'Pending' ? handleApprove : undefined}
                      onReject={isOrder && alert.orderStatus === 'Pending' ? handleReject : undefined}
                    />
                  );
                })
              ) : (
                <div className="bg-[#121212] p-8 rounded-[2.5rem] text-center border border-dashed border-white/5 shadow-xl">
                  <p className="text-slate-500 font-bold text-sm">لا توجد تنبيهات جديدة</p>
                </div>
              )}
            </div>
          </div>

          <div className="bg-[#121212] p-8 rounded-[2.5rem] shadow-2xl border border-white/5 relative overflow-hidden group">
            <div className="absolute top-0 right-0 w-32 h-32 bg-[#D9B07C]/5 blur-3xl rounded-full -mr-16 -mt-16"></div>
            <h2 className="text-xl font-black text-white mb-8 relative z-10">نشاط الورش</h2>
            <div className="space-y-8 relative z-10">
              {data?.workshopsActivity?.length > 0 ? (
                data.workshopsActivity.map((activity, idx) => (
                  <div key={idx} className="flex items-center gap-4 group/item transition-all p-4 hover:bg-white/5 rounded-2xl border border-transparent hover:border-white/10 cursor-pointer relative overflow-hidden">
                    <div className="absolute inset-0 bg-gradient-to-l from-[#D9B07C]/0 via-[#D9B07C]/5 to-transparent opacity-0 group-hover/item:opacity-100 transition-opacity"></div>
                    
                    <div className="relative z-10 shrink-0">
                      <div className="h-14 w-14 rounded-2xl bg-gradient-to-br from-[#2a2a2a] to-[#121212] border border-white/10 flex items-center justify-center text-[#D9B07C] text-lg font-black shadow-lg shadow-black/40 transition-all duration-300 group-hover/item:scale-110 group-hover/item:border-[#D9B07C]/30 group-hover/item:shadow-[#D9B07C]/20">
                        {activity.name?.replace('ورشة', '').replace('ورشه', '').trim()[0] || 'و'}
                      </div>
                      {activity.isOpen && (
                        <div className="absolute -bottom-1 -right-1 flex h-4 w-4 items-center justify-center">
                          <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-emerald-400 opacity-75"></span>
                          <span className="relative inline-flex h-3 w-3 rounded-full bg-emerald-500 border-2 border-[#121212]"></span>
                        </div>
                      )}
                    </div>
                    
                    <div className="flex-1 min-w-0 z-10">
                      <div className="flex justify-between items-start mb-1.5">
                        <p className="text-sm font-black text-white truncate group-hover/item:text-[#D9B07C] transition-colors">{activity.name}</p>
                        <span className="text-[10px] font-bold text-slate-300 bg-white/5 px-2 py-1 rounded-full border border-white/5 flex items-center gap-1 shrink-0 mr-2">
                          <Clock size={10} className="text-[#D9B07C]" />
                          <span dir="ltr">{activity.openTime?.substring(0, 5)} - {activity.closeTime?.substring(0, 5)}</span>
                        </span>
                      </div>
                      
                      <div className="flex items-center gap-2 mb-2">
                        <span className="text-xs text-slate-300 font-bold truncate flex items-center gap-1.5">
                          <span className="w-1.5 h-1.5 rounded-full bg-[#D9B07C]/50"></span>
                          {activity.ownerName}
                        </span>
                        {activity.totalOrders > 0 && (
                          <>
                            <span className="w-1 h-1 rounded-full bg-white/20"></span>
                            <span className="text-[10px] text-emerald-400 font-black bg-emerald-500/10 px-1.5 py-0.5 rounded">
                              {activity.totalOrders} طلب
                            </span>
                          </>
                        )}
                      </div>
                      
                      <div className="flex items-center gap-4 text-[10px] text-slate-500 font-bold">
                        <div className="flex items-center gap-1 truncate max-w-[60%]">
                          <MapPin size={10} className="text-slate-400 shrink-0" />
                          <span className="truncate">{activity.address}</span>
                        </div>
                        <div className="flex items-center gap-1 shrink-0">
                          <Phone size={10} className="text-slate-400 shrink-0" />
                          <span dir="ltr">{activity.phoneNumber}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                ))
              ) : (
                <p className="text-xs text-slate-500 text-center font-bold">لا يوجد نشاط مسجل مؤخراً</p>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AdminHome;
