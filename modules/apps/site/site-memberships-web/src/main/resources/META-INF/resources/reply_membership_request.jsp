<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/init.jsp" %>

<%
String redirect = ParamUtil.getString(request, "redirect");

if (Validator.isNull(redirect)) {
	PortletURL portletURL = renderResponse.createRenderURL();

	portletURL.setParameter("mvcPath", "/view_membership_requests.jsp");

	redirect = portletURL.toString();
}

long groupId = ParamUtil.getLong(request, "groupId");

Group group = GroupLocalServiceUtil.getGroup(groupId);

long membershipRequestId = ParamUtil.getLong(request, "membershipRequestId");

MembershipRequest membershipRequest = MembershipRequestLocalServiceUtil.getMembershipRequest(membershipRequestId);
%>

<portlet:actionURL name="replyMembershipRequest" var="replyMembershipRequestURL">
	<portlet:param name="mvcPath" value="/reply_membership_request.jsp" />
	<portlet:param name="groupId" value="<%= String.valueOf(groupId) %>" />
</portlet:actionURL>

<aui:form action="<%= replyMembershipRequestURL %>" cssClass="container-fluid-1280" method="post" name="fm">
	<aui:input name="redirect" type="hidden" value="<%= redirect %>" />
	<aui:input name="membershipRequestId" type="hidden" value="<%= membershipRequest.getMembershipRequestId() %>" />

	<liferay-ui:error exception="<%= DuplicateGroupException.class %>" message="please-enter-a-unique-name" />
	<liferay-ui:error exception="<%= GroupKeyException.class %>" message="please-enter-a-valid-name" />
	<liferay-ui:error exception="<%= MembershipRequestCommentsException.class %>" message="please-enter-valid-comments" />
	<liferay-ui:error exception="<%= RequiredGroupException.MustNotDeleteCurrentGroup.class %>" message="the-site-cannot-be-deleted-or-deactivated-because-you-are-accessing-the-site" />
	<liferay-ui:error exception="<%= RequiredGroupException.MustNotDeleteGroupThatHasChild.class %>" message="you-cannot-delete-sites-that-have-subsites" />
	<liferay-ui:error exception="<%= RequiredGroupException.MustNotDeleteSystemGroup.class %>" message="the-site-cannot-be-deleted-or-deactivated-because-it-is-a-required-system-site" />

	<aui:model-context bean="<%= membershipRequest %>" model="<%= MembershipRequest.class %>" />

	<c:if test="<%= Validator.isNotNull(group.getDescription()) %>">
		<aui:field-wrapper label="description">
			<p>
				<%= HtmlUtil.escape(group.getDescription()) %>
			</p>
		</aui:field-wrapper>
	</c:if>

	<aui:fieldset-group markupView="lexicon">
		<aui:fieldset>
			<liferay-ui:user-portrait
				userId="<%= membershipRequest.getUserId() %>"
			/>

			<aui:input name="userName" type="resource" value="<%= PortalUtil.getUserName(membershipRequest.getUserId(), StringPool.BLANK) %>" />

			<aui:input name="userComments" readonly="<%= true %>" type="textarea" value="<%= membershipRequest.getComments() %>" />

			<aui:select autoFocus="<%= windowState.equals(WindowState.MAXIMIZED) %>" label="status" name="statusId">
				<aui:option label="approve" value="<%= MembershipRequestConstants.STATUS_APPROVED %>" />
				<aui:option label="deny" value="<%= MembershipRequestConstants.STATUS_DENIED %>" />
			</aui:select>

			<aui:input name="replyComments" />
		</aui:fieldset>
	</aui:fieldset-group>

	<aui:button-row>
		<aui:button cssClass="btn-lg" type="submit" />

		<aui:button cssClass="btn-lg" href="<%= redirect %>" type="cancel" />
	</aui:button-row>
</aui:form>