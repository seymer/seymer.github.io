let lockRefreshing=0;function postStatus(){let s=$("#s");let status=s.val();if(status.length>0){$.post("/t/update",{status:status,in_reply_to_status_id:in_reply_to_status_id,once:once},function(data){if(data.success==1){purgeStatusDraft(memberId);once=data.once;if(mode=='home'){$("#remaining").html('500');refreshHome();}}
s.val('');s.focus();});}}
function deleteStatus(status_id){let item=$("#s_"+status_id);if(item){$.post("/t/delete",{status_id:status_id,once:once},function(data){if(data.success==1){once=data.once;item.fadeOut();}});}}
function replyStatus(username,status_id){in_reply_to_status_id=status_id;const s=$("#s");const s_val=s.val();let value;if(s_val.length==0){value='@'+username+' ';}else{value='@'+username+' '+s_val;}
s.focus().val('').val(value);}
function refreshHome(){if(lockRefreshing==1){return;}else{lockRefreshing=1;}
$.post("/t/refresh",{max_id:head},function(data){if(data.success==1){once=data.once;head=data.head;var ss=$("#statuses");ss.prepend(data.html);}
lockRefreshing=0;});setTimeout(function(){refreshHome();},5000);}
document.addEventListener("DOMContentLoaded",function(event){$(".status").each(function(index,value){if(index==0){head=parseInt(value.id.split('_')[1]);}});if(mode=='home'){setTimeout(function(){refreshHome();},2000);}
$("#s").keydown(function(e){let s=$("#s");let text=s.val()
if(text.length==0){in_reply_to_status_id=0;}
if((e.ctrlKey||e.metaKey)&&e.which===13){e.preventDefault();postStatus();}
let max=500;let remaining=max-text.length;const r=$("#remaining");r.html(remaining);});loadStatusDraft(memberId);$('#s').autosize().blur();$("#s").focus();$('#s').on('input',function(e){saveStatusDraft(memberId);});});