import React from 'react';

const AlertCard = ({ id, title, description, time, icon: Icon, type, onApprove, onReject }) => {
  const styles = {
    emergency: {
      bg: 'bg-red-500/5',
      border: 'border-red-500/20',
      iconBg: 'bg-red-500/10',
      iconColor: 'text-red-400',
      titleColor: 'text-red-400',
    },
    warning: {
      bg: 'bg-orange-500/5',
      border: 'border-orange-500/20',
      iconBg: 'bg-orange-500/10',
      iconColor: 'text-orange-400',
      titleColor: 'text-orange-400',
    },
    info: {
      bg: 'bg-[#D9B07C]/5',
      border: 'border-[#D9B07C]/10',
      iconBg: 'bg-[#D9B07C]/10',
      iconColor: 'text-[#D9B07C]',
      titleColor: 'text-white',
    }
  };

  const style = styles[type] || styles.info;

  return (
    <div className={`${style.bg} ${style.border} border p-5 rounded-[2rem] flex flex-col gap-4 font-tajawal mb-4 hover:border-white/10 transition-all cursor-pointer shadow-lg shadow-black/20`}>
      <div className="flex items-start gap-4 w-full">
        <div className="flex-1 text-right">
          <h4 className={`${style.titleColor} font-black text-base mb-1`}>{title}</h4>
          <p className="text-slate-500 text-xs font-medium leading-relaxed mb-2">{description}</p>
          <span className="text-slate-400 text-[10px] font-bold">{time}</span>
        </div>
        <div className={`${style.iconBg} p-3 rounded-2xl ${style.iconColor} shrink-0`}>
          <Icon size={20} />
        </div>
      </div>
      
      {(onApprove || onReject) && (
        <div className="flex items-center gap-2 mt-2 w-full">
          {onApprove && (
            <button 
              onClick={(e) => { e.stopPropagation(); onApprove(id); }}
              className="flex-1 bg-emerald-500/10 hover:bg-emerald-500/20 text-emerald-500 text-xs font-black py-2.5 rounded-xl transition-colors"
            >
              قبول
            </button>
          )}
          {onReject && (
            <button 
              onClick={(e) => { e.stopPropagation(); onReject(id); }}
              className="flex-1 bg-red-500/10 hover:bg-red-500/20 text-red-500 text-xs font-black py-2.5 rounded-xl transition-colors"
            >
              رفض
            </button>
          )}
        </div>
      )}
    </div>
  );
};

export default AlertCard;
