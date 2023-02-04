func ExampleTicketsClient_BeginCreate() {​

    cred, err := azidentity.NewDefaultAzureCredential(nil)​

    if err != nil {​

        log.Fatalf("failed to obtain a credential: %v", err)​

    }​

    ctx := context.Background()​

    client, err := armsupport.NewTicketsClient("subid", cred, nil)​

    if err != nil {​

        log.Fatalf("failed to create client: %v", err)​

    }​

    poller, err := client.BeginCreate(ctx,​

        "{{subId}}-{{region}}-{{vmSeries}}",​

        armsupport.TicketDetails{​

            Properties: &armsupport.TicketDetailsProperties{​

                Description: to.Ptr("Issue Type: Zone 1,2,3 access\nRegion: {{region}}\nVM Series: {{vmSeries}}\nPlanned Compute usage in Cores: {{coreQty}}\nPlanned UltraDisk usage in GB: {{ultraDiskQty}}\nPlanned Premium SSD v1 usage in GB: {{premiumDiskQty}}"),​

                ContactDetails: &armsupport.ContactProfile{​

                    Country:                  to.Ptr("usa"),​

                    FirstName:                to.Ptr("abc"),​

                    LastName:                 to.Ptr("xyz"),​

                    PreferredContactMethod:   to.Ptr(armsupport.PreferredContactMethodEmail),​

                    PreferredSupportLanguage: to.Ptr("en-US"),​

                    PreferredTimeZone:        to.Ptr("Pacific Standard Time"),​

                    PrimaryEmailAddress:      to.Ptr(abc@contoso.com),​

                },​

                ProblemClassificationID: to.Ptr("/providers/Microsoft.Support/services/{{serviceNameGuid}}/problemClassifications/{{problemClassificationNameGuid}}"),​

                ServiceID:               to.Ptr("/providers/Microsoft.Support/services/{{serviceNameGuid}}"),​

                Severity:                to.Ptr(armsupport.SeverityLevelModerate),​

                Title:                   to.Ptr("Enable Zone 1, 2, 3 access for {{vmSeries}} in region {{region}}"),​

            },​

        },​

        nil)​

    if err != nil {​

        log.Fatalf("failed to finish the request: %v", err)​

    }​

    res, err := poller.PollUntilDone(ctx, nil)​

    if err != nil {​

        log.Fatalf("failed to pull the result: %v", err)​

    }​

    // TODO: use response item​

    _ = res​

}​