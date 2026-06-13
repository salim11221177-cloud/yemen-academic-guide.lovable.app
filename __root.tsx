import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import {
  Outlet,
  Link,
  createRootRouteWithContext,
  useRouter,
  HeadContent,
  Scripts,
} from "@tanstack/react-router";
import { useEffect, type ReactNode } from "react";

import appCss from "../styles.css?url";
import { reportLovableError } from "../lib/lovable-error-reporting";
import { Toaster } from "@/components/ui/sonner";

function NotFoundComponent() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-background px-4" dir="rtl">
      <div className="max-w-md text-center">
        <h1 className="text-7xl font-extrabold text-gradient-hero">404</h1>
        <h2 className="mt-4 text-xl font-bold">الصفحة غير موجودة</h2>
        <p className="mt-2 text-sm text-muted-foreground">
          عذراً، الصفحة التي تبحث عنها غير متاحة أو تم نقلها.
        </p>
        <Link
          to="/"
          className="mt-6 inline-flex items-center justify-center rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition"
        >
          العودة للرئيسية
        </Link>
      </div>
    </div>
  );
}

function ErrorComponent({ error, reset }: { error: Error; reset: () => void }) {
  console.error(error);
  const router = useRouter();
  useEffect(() => {
    reportLovableError(error, { boundary: "tanstack_root_error_component" });
  }, [error]);

  return (
    <div className="flex min-h-screen items-center justify-center bg-background px-4" dir="rtl">
      <div className="max-w-md text-center">
        <h1 className="text-xl font-bold">حدث خطأ غير متوقع</h1>
        <p className="mt-2 text-sm text-muted-foreground">
          لم نتمكن من تحميل هذه الصفحة. حاول مجدداً أو عُد للرئيسية.
        </p>
        <div className="mt-6 flex flex-wrap justify-center gap-2">
          <button
            onClick={() => { router.invalidate(); reset(); }}
            className="rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground hover:bg-primary/90"
          >
            إعادة المحاولة
          </button>
          <a href="/" className="rounded-lg border border-border bg-background px-5 py-2.5 text-sm font-semibold hover:bg-accent">
            الرئيسية
          </a>
        </div>
      </div>
    </div>
  );
}

export const Route = createRootRouteWithContext<{ queryClient: QueryClient }>()({
  head: () => ({
    meta: [
      { charSet: "utf-8" },
      { name: "viewport", content: "width=device-width, initial-scale=1" },
      { title: "دليلك الجامعي — منصة الجامعات اليمنية" },
      { name: "description", content: "المنصة الموحدة للجامعات اليمنية: استكشف الجامعات والكليات والتخصصات، وتواصل مع مؤسستك الأكاديمية من مكان واحد." },
      { name: "author", content: "دليلك الجامعي" },
      { property: "og:title", content: "دليلك الجامعي — منصة الجامعات اليمنية" },
      { property: "og:description", content: "المنصة الموحدة للجامعات اليمنية: استكشف الجامعات والكليات والتخصصات، وتواصل مع مؤسستك الأكاديمية من مكان واحد." },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary_large_image" },
      { name: "twitter:title", content: "دليلك الجامعي — منصة الجامعات اليمنية" },
      { name: "twitter:description", content: "المنصة الموحدة للجامعات اليمنية: استكشف الجامعات والكليات والتخصصات، وتواصل مع مؤسستك الأكاديمية من مكان واحد." },
      { property: "og:image", content: "https://pub-bb2e103a32db4e198524a2e9ed8f35b4.r2.dev/32b04b55-4980-4305-876a-5e90f1fcf25d/id-preview-827a57c4--4e261b2b-c468-490b-bd9b-3b54dd3f2acb.lovable.app-1781138445046.png" },
      { name: "twitter:image", content: "https://pub-bb2e103a32db4e198524a2e9ed8f35b4.r2.dev/32b04b55-4980-4305-876a-5e90f1fcf25d/id-preview-827a57c4--4e261b2b-c468-490b-bd9b-3b54dd3f2acb.lovable.app-1781138445046.png" },
    ],
    links: [
      { rel: "stylesheet", href: appCss },
      { rel: "preconnect", href: "https://fonts.googleapis.com" },
      { rel: "preconnect", href: "https://fonts.gstatic.com", crossOrigin: "anonymous" },
      { rel: "stylesheet", href: "https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" },
    ],
  }),
  shellComponent: RootShell,
  component: RootComponent,
  notFoundComponent: NotFoundComponent,
  errorComponent: ErrorComponent,
});

function RootShell({ children }: { children: ReactNode }) {
  return (
    <html lang="ar" dir="rtl">
      <head>
        <HeadContent />
      </head>
      <body>
        {children}
        <Scripts />
      </body>
    </html>
  );
}

function RootComponent() {
  const { queryClient } = Route.useRouteContext();

  return (
    <QueryClientProvider client={queryClient}>
      <Outlet />
      <Toaster richColors position="top-center" dir="rtl" />
    </QueryClientProvider>
  );
}
