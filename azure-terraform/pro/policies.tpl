<policies>
    <inbound>
        <cache-lookup-value key="backend-counter" variable-name="backend-counter" />
        <choose>
            <when condition="@(!context.Variables.ContainsKey("backend-counter"))">
                <set-variable name="backend-counter" value="0" />
                <cache-store-value key="backend-counter" value="0" duration="100" />
            </when>
        </choose>
        <choose>
            <when condition="@(Convert.ToInt32(context.Variables["backend-counter"]) == 0)">
                <set-backend-service backend-id="${backend1}" />
                <set-header name="api-key" exists-action="override">
                    <value>${key1}</value>
                </set-header>
                <set-variable name="backend-counter" value="1" />
                <cache-store-value key="backend-counter" value="1" duration="100" />
            </when>
            <otherwise>
                <set-backend-service backend-id="${backend2}" />
                <set-header name="api-key" exists-action="override">
                    <value>${key2}</value>
                </set-header>
                <set-variable name="backend-counter" value="0" />
                <cache-store-value key="backend-counter" value="0" duration="100" />
            </otherwise>
        </choose>
        <rewrite-uri template="@{return context.Request.OriginalUrl.Path;}" />
        <base />
    </inbound>
    <backend>
        <retry condition="@(context.Response.StatusCode >= 400)" count="3" interval="5" first-fast-retry="true">
            <cache-lookup-value key="backend-counter" variable-name="backend-counter" />
            <choose>
                <when condition="@(Convert.ToInt32(context.Variables["backend-counter"]) == 0)">
                    <set-backend-service backend-id="${backend1}" />
                    <set-header name="api-key" exists-action="override">
                        <value>${key1}</value>
                    </set-header>
                    <set-variable name="backend-counter" value="1" />
                    <cache-store-value key="backend-counter" value="1" duration="100" />
                </when>
                <otherwise>
                    <set-backend-service backend-id="${backend2}" />
                    <set-header name="api-key" exists-action="override">
                        <value>${key2}</value>
                    </set-header>
                    <set-variable name="backend-counter" value="0" />
                    <cache-store-value key="backend-counter" value="0" duration="100" />
                </otherwise>
            </choose>
            <forward-request buffer-request-body="true" />
        </retry>
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>