{% if theme.exturl %}
  <script type="text/javascript" src="{{ url_for(theme.js) }}/src/exturl.js?v={{ theme.version }}"></script>
{% endif %}

{% if theme.local_social_share %}
<script type="text/javascript" src="{{ url_for(theme.js) }}/src/social-share.js?v={{ theme.version }}"></script>

<script type="text/javascript">
$(function() {
	$("#socialShare").socialShare({
		content: $('#posts').find('.post-body').children().first().text(),
		url: window.location.href,
		titile: document.title
	});
});
</script>
{% endif %}
