import { Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { GraduationCap, LogIn, UserPlus, LogOut, LayoutDashboard, Search, User, Building2, ChevronDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";

export function SiteHeader() {
  const { user, roles, signOut } = useAuth();
  const isUniversity = roles.includes("university");
  const isAdmin = roles.includes("admin");
  const dashHref = isAdmin ? "/admin" : isUniversity ? "/university" : "/account";

  const [profile, setProfile] = useState<{ full_name: string | null; email: string | null } | null>(null);

  useEffect(() => {
    if (!user) { setProfile(null); return; }
    supabase.from("profiles").select("full_name,email").eq("id", user.id).maybeSingle()
      .then(({ data }) => setProfile(data ?? null));
  }, [user]);

  const displayName = profile?.full_name
    || (user?.user_metadata as any)?.full_name
    || user?.email?.split("@")[0]
    || "حسابي";
  const avatarUrl = (user?.user_metadata as any)?.avatar_url as string | undefined;
  const initials = (displayName || "?").trim().charAt(0).toUpperCase();

  return (
    <header className="sticky top-0 z-40 border-b border-border/60 bg-background/85 backdrop-blur-xl">
      <div className="container mx-auto flex h-16 items-center justify-between gap-4 px-4 sm:px-6">
        <Link to="/" className="flex items-center gap-2 shrink-0">
          <div className="grid h-10 w-10 place-items-center rounded-xl bg-gradient-hero shadow-soft">
            <GraduationCap className="h-5 w-5 text-primary-foreground" />
          </div>
          <div className="hidden sm:block">
            <div className="text-base font-extrabold leading-tight">دليلك الجامعي</div>
            <div className="text-[10px] text-muted-foreground">منصة الجامعات اليمنية</div>
          </div>
        </Link>

        <nav className="hidden md:flex items-center gap-1 text-sm">
          <Link to="/" className="px-3 py-2 rounded-lg hover:bg-accent transition" activeOptions={{ exact: true }} activeProps={{ className: "text-primary font-bold" }}>
            الرئيسية
          </Link>
          <Link to="/universities" className="px-3 py-2 rounded-lg hover:bg-accent transition" activeProps={{ className: "text-primary font-bold" }}>
            الجامعات
          </Link>
          {!isUniversity && !isAdmin && (
            <Link to="/register-university" className="px-3 py-2 rounded-lg hover:bg-accent transition" activeProps={{ className: "text-primary font-bold" }}>
              تسجيل جامعة
            </Link>
          )}
        </nav>

        <div className="flex items-center gap-2">
          <Link to="/universities" className="md:hidden">
            <Button variant="ghost" size="icon" aria-label="بحث">
              <Search className="h-4 w-4" />
            </Button>
          </Link>

          {user ? (
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <button className="flex items-center gap-2 rounded-full pl-1 pr-2 sm:pr-3 py-1 hover:bg-accent transition cursor-pointer focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring">
                  <Avatar className="h-8 w-8 border border-border">
                    {avatarUrl && <AvatarImage src={avatarUrl} alt={displayName} />}
                    <AvatarFallback className="bg-gradient-hero text-primary-foreground text-xs font-bold">
                      {initials}
                    </AvatarFallback>
                  </Avatar>
                  <span className="hidden sm:inline text-sm font-medium max-w-[140px] truncate">{displayName}</span>
                  <ChevronDown className="h-3.5 w-3.5 text-muted-foreground hidden sm:block" />
                </button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end" className="w-60">
                <DropdownMenuLabel>
                  <div className="flex flex-col">
                    <span className="font-bold truncate">{displayName}</span>
                    <span className="text-xs font-normal text-muted-foreground truncate">{user.email}</span>
                  </div>
                </DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuItem asChild>
                  <Link to="/account" className="cursor-pointer gap-2">
                    <User className="h-4 w-4" /> ملفي الشخصي
                  </Link>
                </DropdownMenuItem>
                <DropdownMenuItem asChild>
                  <Link to={dashHref} className="cursor-pointer gap-2">
                    <LayoutDashboard className="h-4 w-4" /> لوحتي
                  </Link>
                </DropdownMenuItem>
                {!isUniversity && !isAdmin && (
                  <DropdownMenuItem asChild>
                    <Link to="/register-university" className="cursor-pointer gap-2">
                      <Building2 className="h-4 w-4" /> تسجيل جامعة
                    </Link>
                  </DropdownMenuItem>
                )}
                <DropdownMenuSeparator />
                <DropdownMenuItem onClick={signOut} className="cursor-pointer gap-2 text-destructive focus:text-destructive">
                  <LogOut className="h-4 w-4" /> تسجيل الخروج
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          ) : (
            <>
              <Link to="/auth">
                <Button variant="ghost" size="sm" className="gap-2">
                  <LogIn className="h-4 w-4" /> <span className="hidden sm:inline">دخول</span>
                </Button>
              </Link>
              <Link to="/auth">
                <Button variant="hero" size="sm" className="gap-2">
                  <UserPlus className="h-4 w-4" /> <span className="hidden sm:inline">حساب جديد</span>
                </Button>
              </Link>
            </>
          )}
        </div>
      </div>
    </header>
  );
}
